//
//  QuizDetailView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  

import SwiftUI

struct QuizDetailView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            quizDetailDescription
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
        }
        .navigationBarBackButtonHidden()
    }

    var quizDetailDescription: some View {
        VStack(alignment: .center) {
            Text("\(quizManager.levelTitle): \(quizManager.quizData.allQuizContents.count)問")
                .modifier(CustomLabel(foregroundColor: .black, size: 32, fontName: FontFamily.NotoSans.bold))
            Text("3秒のカウント後、\nフラッシュ算形式で問題が出題されます")
                .modifier(CustomLabel(foregroundColor: .black, size: 20, fontName: FontFamily.NotoSansJP.bold))
                .multilineTextAlignment(.center)
                .padding()
            Text("*全て肯定文で並び替えを行なってください")
                .modifier(CustomLabel(foregroundColor: .black, size: 16, fontName: FontFamily.NotoSansJP.regular))
                .padding()
            Spacer().frame(height: 100)
            Button("始める") {
                navigationManager.path.append(.quizView)
            }
            .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSansJP.bold))
            Button("ホームに戻る") {
                quizManager.resetAllQuiz()
                navigationManager.path.removeAll()
            }
            Spacer().frame(height: 200)
        }
    }
}

// MARK: - Preview
struct QuizDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QuizDetailView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
