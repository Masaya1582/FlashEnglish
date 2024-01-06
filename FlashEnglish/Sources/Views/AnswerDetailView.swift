//
//  AnswerDetailView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct AnswerDetailView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                modalView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 100)
            .padding(24)
            .background(
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
            )
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
                quizManager.formattedCorrectAnswer = quizManager.correctAnswer.joined(separator: ",")
                quizManager.formattedCorrectAnswer = quizManager.formattedCorrectAnswer.replacingOccurrences(of: ",", with: " ")
            }
        }
    }

    var modalView: some View {
        VStack(spacing: 42) {
            Text(quizManager.isAnswerCorrect ? "正解!" : "不正解...")
                .modifier(CustomLabel(foregroundColor: Asset.Colors.gray3.swiftUIColor, size: 20))
            Text(quizManager.formattedCorrectAnswer)
                .modifier(CustomLabel(foregroundColor: .black, size: 24))
            nextQuizButton
        }
        .padding(4)
        .background(.white)
        .frame(maxWidth: .infinity)
        .cornerRadius(20)
    }

    var nextQuizButton: some View {
        Button(quizManager.quizData.allQuizContents.count - quizManager.quizNumber == 1 ? "結果を見る" : "次の問題") {
            if quizManager.quizData.allQuizContents.count - quizManager.quizNumber == 1 {
                navigationManager.path.append(.resultView)
            } else {
                quizManager.isTryNextQuiz = true
                quizManager.isSetNextQuiz = true
                quizManager.resetQuiz()
                navigationManager.path.append(.quizView)
            }
        }
        .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.alertRed.swiftUIColor))
    }
}

// MARK: - Preview
struct AnswerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerDetailView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
