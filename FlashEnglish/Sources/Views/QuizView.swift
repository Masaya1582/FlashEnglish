//
//  QuizView.swift
//  FlashEnglish
//
//  Created by MasayaNakakuki on 2024/01/04.
//

import SwiftUI

struct QuizView: View {
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Text("Question \(quizManager.currentIndex + 1)")
                    .modifier(CustomLabel(foregroundColor: Asset.Colors.gray3.swiftUIColor, size: 32))
                Spacer()
                if quizManager.count > 0 {
                    initialCounter
                } else {
                    if quizManager.quizIndex < quizManager.prodQuizContent.count {
                        quizContent
                    }
                }
                Spacer()
            }
            .navigationDestination(for: ViewType.self) { viewType in
                switch viewType {
                case .homeView:
                    HomeView()
                case .quizDetailView:
                    QuizDetailView()
                case .quizView:
                    QuizView()
                case .answerView:
                    AnswerView()
                case .answerDetailView:
                    AnswerDetailView()
                case .resultView:
                    ResultView()
                }
            }
            .onAppear {
                quizManager.startTimerForCountDown()
                if !quizManager.isTryAgain && quizManager.isSetNextQuiz {
                    quizManager.setQuiz(isSetNextQuiz: quizManager.isSetNextQuiz, quizLevel: quizManager.quizLevel ?? .easy)
                }
                if quizManager.isTryAgain {
                    quizManager.isTryAgain = false
                }
                quizManager.quizForRetry = quizManager.prodQuizContent
            }
            .onDisappear {
                quizManager.stopTimer()
            }
            .onChange(of: quizManager.isTryAgain) { isTryAgain in
                if isTryAgain {
                    quizManager.tryAgainCount -= 1
                    quizManager.resetAndRestartQuiz()
                }
            }
            .onChange(of: quizManager.isShowAnswerView) { isShowAnswerView in
                if isShowAnswerView {
                    navigationManager.path.append(.answerView)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }

    // カウントダウン表示
    var initialCounter: some View {
        Text("\(quizManager.count)")
            .modifier(CustomLabel(foregroundColor: .black, size: 48))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 120)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
            )
    }

    // クイズ内容
    var quizContent: some View {
        VStack {
            Spacer()
            Text(quizManager.isTryAgain ? quizManager.quizForRetry[quizManager.quizIndex] : quizManager.prodQuizContent[quizManager.quizIndex])
                .modifier(CustomLabel(foregroundColor: .black, size: 48))
            Spacer()

        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
