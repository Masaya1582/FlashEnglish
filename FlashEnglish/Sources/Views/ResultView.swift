//
//  ResultView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct ResultView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Text("Result: \(quizManager.correctCount)問正解")
                    .modifier(CustomLabel(foregroundColor: .black, size: 24, fontName: FontFamily.NotoSansJP.bold))
                Spacer()
                Button("Back") {
                    // 全問正解且つヒントを見ないでクリアしたら王冠をつける
                    print("ヒント見た: \(quizManager.isShowHint)")
                    if (quizManager.quizData.allQuizContents.count == quizManager.correctCount) && !quizManager.isShowHint {
                        UserDefaults.standard.set(true, forKey: "\(quizManager.levelTitle)Completed")
                    }
                    quizManager.resetAllQuiz()
                    navigationManager.path.removeAll()
                }
                .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSans.bold))
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Preview
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
