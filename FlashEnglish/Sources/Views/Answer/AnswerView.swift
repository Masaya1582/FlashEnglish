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
                    Spacer()
                    userAnswerField
                    textFieldAndHint()
                    bottomField()
                        .alert(isPresented: $quizManager.isShowAlertView) {
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
                if quizManager.isShowAnswerResultAnimation {
                    if quizManager.isAnswerCorrect {
                        LottieView(lottieFile: L10n.lottieCorrect)
                    } else {
                        LottieView(lottieFile: L10n.lottieIncorrect)
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
            Text("\(quizManager.userAnswerInputs)")
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
        TextField("正しい順番に並び替える", text: $quizManager.userAnswerInputs)
            .keyboardType(.asciiCapable)
            .modifier(CustomTextField())
        // ヒント
        if quizManager.isShowHint && quizManager.tryAgainRemainCount < 1 && quizManager.isQuizDataShuffled {
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
        Button {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            quizManager.judgeAnswer()
        } label: {
            Text("解答")
                .modifier(CustomButton(foregroundColor: .white, backgroundColor: quizManager.userAnswerInputs.isEmpty ? Asset.Colors.gray7.swiftUIColor : Asset.Colors.buttonColor.swiftUIColor, fontName: FontFamily.NotoSansJP.bold, width: UIScreen.main.bounds.width / 1.4, height: UIScreen.main.bounds.height / 32))
        }
        .disabled(quizManager.userAnswerInputs.isEmpty)
        Button("もう一度みる (あと\(quizManager.tryAgainRemainCount)回)") {
            quizManager.isTryAgainTriggered = true
            quizManager.isShowAnswerView = false
            quizManager.tryAgainRemainCount -= 1
            navigationManager.path.removeLast()
        }
        .disabled(quizManager.tryAgainRemainCount < 1)
        Button("ホームに戻る") {
            quizManager.isShowAlertView = true
        }
        Spacer()
        AdMobBannerView()
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height / 12)
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
