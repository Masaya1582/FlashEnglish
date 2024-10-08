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
    @Binding var presentSideMenu: Bool
    private let levelItem: [LevelItem] = [
        LevelItem(image: Asset.Assets.imgJuniorHighSchool.swiftUIImage, title: "TEST中学生レベル", levelCase: .juniorHighSchool),
        LevelItem(image: Asset.Assets.imgHighSchool.swiftUIImage, title: "高校生レベル", levelCase: .highSchool),
        LevelItem(image: Asset.Assets.imgCollege.swiftUIImage, title: "大学生レベル", levelCase: .college),
        LevelItem(image: Asset.Assets.imgBusinessman.swiftUIImage, title: "社会人レベル", levelCase: .businessman),
        LevelItem(image: Asset.Assets.imgExpert.swiftUIImage, title: "専門家レベル", levelCase: .expert),
        LevelItem(image: Asset.Assets.imgMonster.swiftUIImage, title: "人外レベル", levelCase: .monster)
    ]
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationManager.navigationPath) {
            stageSelectorView
                .gesture(
                    DragGesture(minimumDistance: 50, coordinateSpace: .local)
                        .onEnded { dragValue in
                            if dragValue.translation.width > 0 && dragValue.translation.height < dragValue.translation.width {
                                presentSideMenu.toggle()
                            }
                        }
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
                .navigationBarItems(
                    leading:
                        Button {
                            presentSideMenu.toggle()
                        } label: {
                            Image(systemName: "list.bullet")
                                .foregroundColor(Asset.Colors.black.swiftUIColor)
                        }
                )
        }
    }

    private var stageSelectorView: some View {
        VStack {
            Text("フラッシュ英文法だ")
                .modifier(CustomLabel(foregroundColor: Asset.Colors.black.swiftUIColor, size: 32, fontName: FontFamily.NotoSansJP.bold))
                .padding()
            Spacer().frame(height: 20)
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(levelItem) { levelItem in
                        LevelGridItem(levelItem: levelItem, tapAction: {
                            withAnimation {
                                FirebaseAnalytics.logEvent(.selectedLevel(levelItem.title))
                                quizManager.loadQuizData(quizLevel: levelItem.levelCase)
                                navigationManager.navigationPath.append(.quizDetailView)
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
        HomeView(presentSideMenu: .constant(false))
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
