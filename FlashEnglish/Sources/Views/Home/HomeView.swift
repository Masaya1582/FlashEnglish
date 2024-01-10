//
//  HomeView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager
    private let levelItem: [LevelItem] = [
        LevelItem(image: Asset.Assets.imgJuniorHighSchool.swiftUIImage, title: "中学生レベル", levelCase: .juniorHighSchool),
        LevelItem(image: Asset.Assets.imgHighSchool.swiftUIImage, title: "高校生レベル", levelCase: .highSchool),
        LevelItem(image: Asset.Assets.imgCollege.swiftUIImage, title: "大学生レベル", levelCase: .college),
        LevelItem(image: Asset.Assets.imgBusinessman.swiftUIImage, title: "社会人レベル", levelCase: .businessman),
        LevelItem(image: Asset.Assets.imgExpert.swiftUIImage, title: "専門家レベル", levelCase: .expert),
        LevelItem(image: Asset.Assets.imgMonster.swiftUIImage, title: "人外レベル", levelCase: .monster)
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
                    case .scoreView:
                        ScoreView()
                    }
                }
                .navigationBarItems(
                    leading: // 左側
                    Button {
                        // TODO: - Show Menuリスト
                    } label: {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.black)
                    }
                )
        }
    }

    var homeDescription: some View {
        VStack {
            Text("フラッシュ英文法")
                .modifier(CustomLabel(foregroundColor: .black, size: 32, fontName: FontFamily.NotoSansJP.bold))
                .padding()
            Spacer().frame(height: 20)
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(levelItem) { levelItem in
                        LevelGridItem(levelItem: levelItem, tapAction: {
                            withAnimation {
                                quizManager.loadQuizData(quizLevel: levelItem.levelCase)
                                navigationManager.path.append(.quizDetailView)
                            }
                        })
                        .overlay(
                            quizManager.isLevelCompleted(level: levelItem.title) ? Asset.Assets.imgCrown.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                            : nil,
                            alignment: .topTrailing
                        )
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
