//
//  HomeView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            homeDescription
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
    }

    var homeDescription: some View {
        VStack {
            Text("フラッシュ英文法")
                .modifier(CustomLabel(foregroundColor: .black, size: 32))
                .padding()
            Text("*全て肯定文で並び替えを行なってください")
                .modifier(CustomLabel(foregroundColor: .black, size: 16))
                .padding()
            Spacer().frame(height: 20)
            ForEach(QuizLevel.allCases, id: \.self) { level in
                Button(level.rawValue) {
                    navigationManager.path.append(.quizDetailView)
                    quizManager.setQuiz(isSetNextQuiz: false, quizLevel: level)
                }
                .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor))
            }
            Spacer().frame(height: 120)
        }
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
