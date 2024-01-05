//
//  ContentView.swift
//  FlashEnglish
//
//  Created by MasayaNakakuki on 2024/01/04.
//

import SwiftUI

struct HomeView: View {
    @State private var count = 3
    @State private var timer: Timer?
    @State private var quizTimer: Timer?
    @State private var currentIndex = 0
    @State private var allQuizDataArray: [String] = []
    @State private var eachQuizArray: [String] = []
    @State private var formattedQuizArray: [String] = []
    @State private var shuffledQuizArray: [String] = []
    @State private var isShowAnswerView = false
    @State private var isTryOneMore = false
    @State private var quizForOneMore: [String] = []
    @State private var tryAgainCount = 3

    var body: some View {
        VStack {
            if count > 0 {
                initialCounter
            } else {
                if currentIndex < shuffledQuizArray.count {
                    quiz
                }
            }
        }
        .fullScreenCover(isPresented: $isShowAnswerView) {
            AnswerView(tryAgainCount: $tryAgainCount, correctAnswer: $formattedQuizArray, isTryOneMore: $isTryOneMore, isShowAnswerView: $isShowAnswerView)
        }
        .onAppear {
            startTimer()
            setupQuizData()
            quizForOneMore = shuffledQuizArray
        }
        .onDisappear {
            stopTimer()
            tryAgainCount -= 1
            resetAndRestartQuiz()
        }
        .onChange(of: isTryOneMore) { newValue in
            if newValue {
                resetAndRestartQuiz()
            }
        }
        .navigationBarBackButtonHidden()
    }

    var initialCounter: some View {
        Text("\(count)")
            .modifier(CustomLabel(foregroundColor: .black, size: 48))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 120)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
            )
    }

    var quiz: some View {
        Text(isTryOneMore ? quizForOneMore[currentIndex] : shuffledQuizArray[currentIndex])
            .modifier(CustomLabel(foregroundColor: .black, size: 48))
    }

    private func resetAndRestartQuiz() {
        count = 3
        currentIndex = 0
        shuffledQuizArray = quizForOneMore
    }

    private func setupQuizData() {
        allQuizDataArray = loadCSV(with: "quiz1").shuffled()
        eachQuizArray.append(allQuizDataArray[currentIndex])
        formattedQuizArray = eachQuizArray.first?
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []
        shuffledQuizArray = formattedQuizArray
        shuffledQuizArray.shuffle()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if count > 0 {
                count -= 1
                if count == 0 {
                    startQuizTimer()
                }
            }
        }
    }

    private func startQuizTimer() {
        quizTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            if currentIndex < (isTryOneMore ? quizForOneMore.count : shuffledQuizArray.count) {
                currentIndex += 1
            } else {
                quizTimer?.invalidate()
                quizTimer = nil
                isShowAnswerView = true
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        quizTimer?.invalidate()
        timer = nil
        quizTimer = nil
        currentIndex = 0
    }

    private func loadCSV(with name: String) -> [String] {
        guard let csvBundle = Bundle.main.path(forResource: name, ofType: "csv") else {
            fatalError("CSV not found")
        }
        var csvDataArray: [String] = []
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: .utf8)
            csvDataArray = csvData.components(separatedBy: "\n")
            csvDataArray.removeLast()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return csvDataArray
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
