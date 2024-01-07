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
            VStack {
                quizDetailDescription
                quizButton
            }
            .padding(16)
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
            Text(L10n.mainDescription)
                .modifier(CustomLabel(foregroundColor: .black, size: 20, fontName: FontFamily.NotoSansJP.bold))
                .multilineTextAlignment(.center)
                .padding()
            Text(L10n.subDescription)
                .modifier(CustomLabel(foregroundColor: .black, size: 16, fontName: FontFamily.NotoSansJP.regular))
                .padding()
        }
        .padding(4)
        .background(Asset.Colors.descriptionBackground.swiftUIColor.opacity(0.3))
        .frame(maxWidth: .infinity)
        .cornerRadius(20)
        .padding(.bottom, 20)
    }

    var quizButton: some View {
        VStack {
            Button("始める") {
                navigationManager.path.append(.quizView)
            }
            .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSansJP.bold))
            Button("ホームに戻る") {
                quizManager.resetAllQuiz()
                navigationManager.path.removeAll()
            }
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
