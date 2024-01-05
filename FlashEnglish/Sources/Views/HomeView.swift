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
    // @State private var currentIndex = 0
    // @State private var allQuizDataArray: [String] = []
    @State private var eachQuizArray: [String] = []
    // @State private var formattedQuizArray: [String] = []
    // @State private var shuffledQuizArray: [String] = []
    @State private var isShowAnswerView = false
    @State private var isTryAgain = false
    @State private var quizForRetry: [String] = []
    @State private var tryAgainCount = 3
    @Binding var isSetNextQuiz: Bool
    @ObservedObject var quizManager = QuizManager()

    var body: some View {
        VStack {
            if count > 0 {
                initialCounter
            } else {
                if quizManager.currentIndex < quizManager.shuffledQuizArray.count {
                    quiz
                }
            }
        }
        .fullScreenCover(isPresented: $isShowAnswerView) {
            AnswerView(tryAgainCount: $tryAgainCount, correctAnswer: $quizManager.formattedQuizArray, isTryOneMore: $isTryAgain, isShowAnswerView: $isShowAnswerView)
        }
        .onAppear {
            startTimer()
            quizManager.setQuiz(isSetNextQuiz: isSetNextQuiz)
            quizForRetry = quizManager.shuffledQuizArray
        }
        .onDisappear {
            stopTimer()
            tryAgainCount -= 1
        }
        .onChange(of: isTryAgain) { newValue in
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
        Text(isTryAgain ? quizForRetry[quizManager.currentIndex] : quizManager.shuffledQuizArray[quizManager.currentIndex])
            .modifier(CustomLabel(foregroundColor: .black, size: 48))
    }

    private func resetAndRestartQuiz() {
        count = 3
        quizManager.currentIndex = 0
        quizManager.shuffledQuizArray = quizForRetry
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
            if quizManager.currentIndex < (isTryAgain ? quizForRetry.count : quizManager.shuffledQuizArray.count) {
                quizManager.currentIndex += 1
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
        quizManager.currentIndex = 0
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
    @State static var isShowAnswerView = false
    static var previews: some View {
        HomeView(isSetNextQuiz: $isShowAnswerView)
    }
}
