//
//  ScoreView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  

import SwiftUI

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
                    medalView()
                    Spacer().frame(height: 80)
                    Text(quizManager.scoreTitle)
                        .modifier(CustomLabel(foregroundColor: .black, size: 28, fontName: FontFamily.NotoSansJP.bold))
                    Button("シェアする") {
                        // シェアボタン
                    }
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.blue.swiftUIColor, fontName: FontFamily.NotoSans.bold))
                    Button("ホームに戻る") {
                        quizManager.resetAllQuiz()
                        navigationManager.path.removeAll()
                    }
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSans.bold))
                    Spacer()
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
    private func medalView() -> some View {
        VStack {
            if quizManager.quizData.allQuizContents.count == quizManager.correctCount {
                Asset.Assets.imgScoreGold.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
                Text("You are a Genius!")
                    .modifier(CustomLabel(foregroundColor: .black, size: 28, fontName: FontFamily.NotoSansJP.bold))
            } else if quizManager.correctCount / quizManager.quizData.allQuizContents.count * 100 > 50 {
                Asset.Assets.imgScoreSilver.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
                Text("You are awesome!")
                    .modifier(CustomLabel(foregroundColor: .black, size: 28, fontName: FontFamily.NotoSansJP.bold))
            } else {
                Asset.Assets.imgScoreBronze.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
                Text("Let's try again!")
                    .modifier(CustomLabel(foregroundColor: .black, size: 28, fontName: FontFamily.NotoSansJP.bold))
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
