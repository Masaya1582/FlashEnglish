//
//  HomeView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack(spacing: 10) {
                Text("フラッシュ暗記法")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                Text("フラッシュ形式で出題される英単語を覚え合わせて正しい英文法を作ろう！")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                ForEach(QuizLevel.allCases, id: \.self) { level in
                    Button(level.rawValue) {
                        navigationManager.path.append(.quizDetailView)
                        quizManager.setQuiz(isSetNextQuiz: false, quizLevel: level)
                    }
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor))
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
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
