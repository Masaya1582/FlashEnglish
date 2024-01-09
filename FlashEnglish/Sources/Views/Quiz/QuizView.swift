//
//  QuizView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/04.
//

import SwiftUI

struct QuizView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Text("Question \(quizManager.quizNumber + 1)")
                    .modifier(CustomLabel(foregroundColor: .black, size: 32, fontName: FontFamily.NotoSans.bold))
                Spacer()
                if quizManager.countDown > 0 {
                    countDownCircle
                } else if quizManager.eachQuizWordNumber < quizManager.productionQuizContentArray.count {
                    quizContent
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
                case .scoreView:
                    ScoreView()
                }
            }
            .onAppear {
                quizManager.startTimerForCountDown()
                if !quizManager.isTryAgainTriggered && quizManager.isSetNextQuiz {
                    quizManager.setQuizData()
                }
                if quizManager.isTryAgainTriggered {
                    quizManager.resetAndRestartQuiz()
                }
            }
            .onDisappear {
                quizManager.resetCount()
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
    var countDownCircle: some View {
        Text("\(quizManager.countDown)")
            .modifier(CustomLabel(foregroundColor: .black, size: 48, fontName: FontFamily.NotoSans.bold))
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
            Text(quizManager.isTryAgainTriggered ? quizManager.quizContentForTryAgain[quizManager.eachQuizWordNumber] : quizManager.productionQuizContentArray[quizManager.eachQuizWordNumber])
                .modifier(CustomLabel(foregroundColor: .black, size: 48, fontName: FontFamily.NotoSans.bold))
            Spacer()
        }
    }
}

// MARK: - Preview
struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
