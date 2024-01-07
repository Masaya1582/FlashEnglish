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
                    Text("Result: \(quizManager.correctCount)問正解")
                        .modifier(CustomLabel(foregroundColor: .black, size: 24, fontName: FontFamily.NotoSansJP.bold))
                    Spacer()
                    Button("Back") {
                        quizManager.resetAllQuiz()
                        navigationManager.path.removeAll()
                    }
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSans.bold))
                    Spacer()
                }
                quizManager.isShowPerfectAnimation ? LottieView(lottieFile: "lottie_perfect") : nil
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

}

// MARK: - Preview
struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
