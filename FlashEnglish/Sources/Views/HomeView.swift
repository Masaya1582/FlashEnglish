//
//  HomeView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

enum QuizLevel: String, CaseIterable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
}

struct HomeView: View {
    @State private var isShowQuizDetailView = false
    @EnvironmentObject var quizManager: QuizManager

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                NavigationLink(destination: QuizDetailView(), isActive: $isShowQuizDetailView) {}
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
                        isShowQuizDetailView = true
                        quizManager.setQuiz(isSetNextQuiz: false, quizLevel: level)
                    }
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor))
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(QuizManager())
    }
}
