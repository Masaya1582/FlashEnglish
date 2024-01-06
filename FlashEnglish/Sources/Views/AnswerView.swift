//
//  AnswerView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct AnswerView: View {
    // MARK: - Properties
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                if quizManager.isShowDescriptionModalView {
                    AnswerDetailView()
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .zIndex(1)
                }
                VStack(spacing: 20) {
                    Text("あなたの解答:")
                        .modifier(CustomLabel(foregroundColor: .black, size: 24, fontName: FontFamily.NotoSansJP.bold))
                    Text("\(quizManager.textFieldInputs)")
                        .modifier(CustomLabel(foregroundColor: .black, size: 24, fontName: FontFamily.NotoSansJP.bold))
                        .multilineTextAlignment(.center)
                    TextField("正しい順番に並び替えよう", text: $quizManager.textFieldInputs)
                        .modifier(CustomTextField())
                    Button("解答") {
                        quizManager.judgeAnswer()
                    }
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSansJP.bold))
                    Button("もう一度みる (あと\(quizManager.tryAgainRemainCount)回)") {
                        quizManager.isTryAgainTriggered = true
                        quizManager.isShowAnswerView = false
                        navigationManager.path.removeLast()
                    }
                    .disabled(quizManager.tryAgainRemainCount < 1)
                    Button("ホームに戻る") {
                        quizManager.isShowAlert = true
                    }
                    .alert(isPresented: $quizManager.isShowAlert) {
                        Alert(
                            title: Text("確認"),
                            message: Text("ホーム画面に戻りますがよろしいですか？\n*クイズデータは破棄されます"),
                            primaryButton: .destructive(Text("ホームに戻る")) {
                                quizManager.resetAllQuiz()
                                navigationManager.path.removeAll()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                if quizManager.isShowMaruBatsu {
                    if quizManager.isAnswerCorrect {
                        withAnimation {
                            Asset.Assets.imgCorrect.swiftUIImage
                                .resizable()
                                .modifier(CustomImage(width: 280, height: 280))
                        }
                    } else {
                        withAnimation {
                            Asset.Assets.imgIncorrect.swiftUIImage
                                .resizable()
                                .modifier(CustomImage(width: 280, height: 280))
                        }
                    }
                }
            }
        }
        .onDisappear {
            quizManager.isTryAgainTriggered = false
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Preview
struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
