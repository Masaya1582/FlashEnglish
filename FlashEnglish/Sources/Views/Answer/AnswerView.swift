//
//  AnswerView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
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
                    userAnswerField
                    textFieldAndHint()
                    bottomField()
                    .alert(isPresented: $quizManager.isShowAlert) {
                        Alert(
                            title: Text("確認"),
                            message: Text(L10n.alertDetail),
                            primaryButton: .destructive(Text("ホームに戻る")) {
                                quizManager.resetAllQuiz()
                                navigationManager.path.removeAll()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .padding(.horizontal, 12)
                if quizManager.isShowMaruBatsu {
                    if quizManager.isAnswerCorrect {
                        LottieView(lottieFile: "lottie_correct")
                    } else {
                        LottieView(lottieFile: "lottie_incorrect")
                    }
                }
            }
        }
        .onDisappear {
            if quizManager.tryAgainRemainCount < 1 {
                quizManager.isShowHint = true
            }
        }
        .navigationBarBackButtonHidden()
    }

    var userAnswerField: some View {
        VStack {
            Text("あなたの解答:")
                .modifier(CustomLabel(foregroundColor: .black, size: 24, fontName: FontFamily.NotoSansJP.bold))
            Text("\(quizManager.textFieldInputs)")
                .modifier(CustomLabel(foregroundColor: .black, size: 24, fontName: FontFamily.NotoSansJP.bold))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Asset.Colors.descriptionBackground.swiftUIColor.opacity(0.3))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func textFieldAndHint() -> some View {
        TextField("正しい順番に並び替える", text: $quizManager.textFieldInputs)
            .modifier(CustomTextField())
        // ヒント
        if quizManager.isShowHint && quizManager.tryAgainRemainCount < 1 {
            Button(action: {
                withAnimation {
                    quizManager.isFlipHint.toggle()
                }
            }) {
                HStack {
                    Text(quizManager.isFlipHint ? "閉じる" : "ヒントを見る(並び替える前の単語がみれます)")
                    Image(systemName: quizManager.isFlipHint ? "chevron.up" : "chevron.down")
                }
                .modifier(CustomLabel(foregroundColor: .blue, size: 12, fontName: FontFamily.NotoSansJP.bold))
            }
            if quizManager.isFlipHint {
                Text(quizManager.productionQuizContentArray.joined(separator: " "))
                    .modifier(CustomLabel(foregroundColor: Asset.Colors.gray1.swiftUIColor, size: 12, fontName: FontFamily.NotoSans.bold))
            }
        }
    }

    @ViewBuilder
    private func bottomField() -> some View {
        Button("解答") {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            quizManager.judgeAnswer()
        }
        .modifier(CustomButton(foregroundColor: .white, backgroundColor: quizManager.textFieldInputs.isEmpty ? Asset.Colors.gray7.swiftUIColor : Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSansJP.bold))
        .disabled(quizManager.textFieldInputs.isEmpty)
        Button("もう一度みる (あと\(quizManager.tryAgainRemainCount)回)") {
            quizManager.isTryAgainTriggered = true
            quizManager.isShowAnswerView = false
            quizManager.tryAgainRemainCount -= 1
            navigationManager.path.removeLast()
        }
        .disabled(quizManager.tryAgainRemainCount < 1)
        Button("ホームに戻る") {
            quizManager.isShowAlert = true
        }
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