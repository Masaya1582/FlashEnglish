//
//  ScoreView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  

import SwiftUI
import GoogleMobileAds

struct ScoreView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("\(quizManager.correctCount)/\(quizManager.quizData.allQuizContents.count)問正解")
                        .modifier(CustomLabel(foregroundColor: .black, size: 32, fontName: FontFamily.NotoSansJP.bold))
                    Spacer()
                    levelCircleView()
                    Spacer().frame(height: 12)
                    Button(action: {
                        withAnimation {
                            quizManager.isShowAllQuizData.toggle()
                        }
                    }) {
                        HStack {
                            Text(quizManager.isShowAllQuizData ? "閉じる" : "問題一覧を見る")
                            Image(systemName: quizManager.isFlipHint ? "chevron.up" : "chevron.down")
                        }
                        .modifier(CustomLabel(foregroundColor: .blue, size: 12, fontName: FontFamily.NotoSansJP.bold))
                    }
                    if quizManager.isShowAllQuizData {
                        List(quizManager.quizDataForScoreView, id: \.self) { quizContent in
                            Text(quizContent)
                                .modifier(CustomLabel(foregroundColor: .black, size: 24, fontName: FontFamily.NotoSans.bold))
                        }
                        .listStyle(.inset)
                    }
                    if !quizManager.isShowAllQuizData {
                        Button("シェアする") {
                            quizManager.shareApp(shareText: "\(quizManager.correctCount)/\(quizManager.quizData.allQuizContents.count)問正解しました!\n#フラッシュ英文法")
                        }
                        .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.blue.swiftUIColor, fontName: FontFamily.NotoSans.bold, width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 32))
                        Button("ホームに戻る") {
                            quizManager.resetAllQuiz()
                            navigationManager.path.removeAll()
                        }
                        .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSans.bold, width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 32))
                    }
                    Spacer()
                    AdMobBannerView()
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height / 12)
                }
                quizManager.isShowPerfectAnimation ? LottieView(lottieFile: L10n.lottiePerfect) : nil
            }
            .onAppear {
                // 全問正解且つヒントを見ないでクリアしたら王冠をつける
                if (quizManager.quizData.allQuizContents.count == quizManager.correctCount) && !quizManager.isShowHint {
                    quizManager.isShowPerfectAnimation = true
                    UserDefaults.standard.set(true, forKey: "\(quizManager.levelTitle)Completed")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        withAnimation {
                            quizManager.isShowPerfectAnimation = false
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }

    @ViewBuilder
    private func levelCircleView() -> some View {
        VStack {
            switch quizManager.quizLevel {
            case .juniorHighSchool:
                Asset.Assets.imgJuniorHighSchool.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
            case .highSchool:
                Asset.Assets.imgHighSchool.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
            case .college:
                Asset.Assets.imgCollege.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
            case .businessman:
                Asset.Assets.imgBusinessman.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
            case .expert:
                Asset.Assets.imgExpert.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
            case .monster:
                Asset.Assets.imgMonster.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
            default:
                Asset.Assets.imgJuniorHighSchool.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
            }
        }
    }
}

// MARK: - Preview
struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
