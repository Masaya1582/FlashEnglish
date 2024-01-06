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
    private let levelItem: [LevelItem] = [
        LevelItem(image: Asset.Assets.imgBeginner.swiftUIImage, title: "中学生レベル", levelCase: .juniorHighSchool),
        LevelItem(image: Asset.Assets.imgBeginner.swiftUIImage, title: "高校生レベル", levelCase: .hightSchool),
        LevelItem(image: Asset.Assets.imgBeginner.swiftUIImage, title: "大学生レベル", levelCase: .college),
        LevelItem(image: Asset.Assets.imgBeginner.swiftUIImage, title: "社会人レベル", levelCase: .businessman),
        LevelItem(image: Asset.Assets.imgBeginner.swiftUIImage, title: "専門家レベル", levelCase: .professor),
        LevelItem(image: Asset.Assets.imgBeginner.swiftUIImage, title: "人外レベル", levelCase: .monster)
    ]
    private let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

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
                .modifier(CustomLabel(foregroundColor: .black, size: 32, fontName: FontFamily.NotoSansJP.bold))
                .padding()
            Text("*全て肯定文で並び替えを行なってください")
                .modifier(CustomLabel(foregroundColor: .black, size: 16, fontName: FontFamily.NotoSansJP.bold))
                .padding()
            Spacer().frame(height: 20)
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(levelItem) { levelItem in
                        LevelGridItem(levelItem: levelItem, tapAction: {
                            withAnimation {
                                navigationManager.path.append(.quizDetailView)
                                quizManager.setQuiz(isSetNextQuiz: false, quizLevel: levelItem.levelCase)
                            }
                        })
                    }
                }
                .padding(.horizontal, 16)
            }
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
