//
//  QuizView.swift
//  FlashEnglish
//
//  Created by MasayaNakakuki on 2024/01/04.
//

import SwiftUI

struct QuizView: View {
    @State private var count = 3
    @State private var timer: Timer?
    @State private var quizTimer: Timer?
    @State private var eachQuizArray: [String] = []
    @State private var isShowAnswerView = false
    @State private var isTryAgain = false
    @State private var quizForRetry: [String] = []
    @State private var tryAgainCount = 3
    @Binding var isSetNextQuiz: Bool
    @EnvironmentObject var quizManager: QuizManager

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AnswerView(tryAgainCount: $tryAgainCount, correctAnswer: $quizManager.formattedQuizArray, isTryOneMore: $isTryAgain, isShowAnswerView: $isShowAnswerView), isActive: $isShowAnswerView) {
                }
                if count > 0 {
                    initialCounter
                } else {
                    if quizManager.quizIndex < quizManager.prodQuizContent.count {
                        quizContent
                    }
                }
            }
            .onAppear {
                startTimer()
                if !isTryAgain && isSetNextQuiz {
                    quizManager.setQuiz(isSetNextQuiz: isSetNextQuiz, quizLevel: quizManager.quizLevel ?? .easy)
                }
                quizForRetry = quizManager.prodQuizContent
            }
            .onDisappear {
                stopTimer()
            }
            .onChange(of: isTryAgain) { isTryAgain in
                if isTryAgain {
                    tryAgainCount -= 1
                    resetAndRestartQuiz()
                }
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

    var quizContent: some View {
        VStack {
            Text("Question \(quizManager.currentIndex + 1)")
                .modifier(CustomLabel(foregroundColor: Asset.Colors.gray3.swiftUIColor, size: 32))
            Spacer()
            Text(isTryAgain ? quizForRetry[quizManager.quizIndex] : quizManager.prodQuizContent[quizManager.quizIndex])
                .modifier(CustomLabel(foregroundColor: .black, size: 48))
            Spacer()

        }
    }

    private func resetAndRestartQuiz() {
        count = 3
        quizManager.quizIndex = 0
        quizManager.prodQuizContent = quizForRetry
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
            if quizManager.quizIndex < (isTryAgain ? quizForRetry.count : quizManager.prodQuizContent.count) {
                quizManager.quizIndex += 1
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
    }
}

struct QuizView_Previews: PreviewProvider {
    @State static var isShowAnswerView = false
    static var previews: some View {
        QuizView(isSetNextQuiz: $isShowAnswerView)
            .environmentObject(QuizManager())
    }
}
