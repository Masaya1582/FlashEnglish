//
//  AnswerDetailView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//

import SwiftUI

struct AnswerDetailView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationManager.navigationPath) {
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
                    HomeView(presentSideMenu: .constant(false))
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
                quizManager.formattedCorrectAnswer = quizManager.correctAnswer.joined(separator: ",")
                quizManager.formattedCorrectAnswer = quizManager.formattedCorrectAnswer.replacingOccurrences(of: ",", with: " ")
            }
        }
    }

    private var modalView: some View {
        VStack(spacing: 42) {
            Text(quizManager.isAnswerCorrect ? "正解!" : "不正解...")
                .modifier(CustomLabel(foregroundColor: Asset.Colors.defaultBlack.swiftUIColor, size: 20, fontName: FontFamily.NotoSansJP.bold))
            Text(quizManager.formattedCorrectAnswer)
                .modifier(CustomLabel(foregroundColor: Asset.Colors.defaultBlack.swiftUIColor, size: 24, fontName: FontFamily.NotoSans.bold))
            nextQuizButton()
        }
        .frame(maxWidth: .infinity)
        .padding(4)
        .background(.white)
        .cornerRadius(20)
    }

    @ViewBuilder
    private func nextQuizButton() -> some View {
        VStack {
            Button {
                if quizManager.allQuizContents.count - quizManager.quizNumber == 1 {
                    navigationManager.navigationPath.append(.scoreView)
                } else {
                    quizManager.isTryNextQuiz = true
                    quizManager.isSetNextQuiz = true
                    quizManager.resetQuiz()
                    navigationManager.navigationPath.append(.quizView)
                }
            } label: {
                Text(quizManager.allQuizContents.count - quizManager.quizNumber == 1 ? "結果を見る" : "次の問題")
                    .modifier(CustomButton(foregroundColor: Asset.Colors.defaultWhite.swiftUIColor, backgroundColor: (quizManager.allQuizContents.count - quizManager.quizNumber == 1) ? Asset.Colors.defaultBlue.swiftUIColor : Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSansJP.bold, width: UIScreen.main.bounds.width / 1.4, height: UIScreen.main.bounds.height / 32))
            }
            Button("ホームに戻る") {
                quizManager.isShowAlertView = true
            }
            .alert(isPresented: $quizManager.isShowAlertView) {
                Alert(
                    title: Text("確認"),
                    message: Text(L10n.alertDetail),
                    primaryButton: .destructive(Text("ホームに戻る")) {
                        quizManager.resetAllQuiz()
                        navigationManager.navigationPath.removeAll()
                    },
                    secondaryButton: .cancel()
                )
            }
            Spacer().frame(height: 12)
        }
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
