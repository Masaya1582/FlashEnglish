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
                        .modifier(CustomLabel(foregroundColor: .black, size: 24))
                    Text("\(quizManager.textFieldInputs)")
                        .modifier(CustomLabel(foregroundColor: .black, size: 24))
                        .multilineTextAlignment(.center)
                    TextField("正しい順番に並び替えよう", text: $quizManager.textFieldInputs)
                        .modifier(CustomTextField())
                    Button("GO") {
                        quizManager.judgeAnswer()
                    }
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: .orange))
                    Button("もう一度みる (あと\(quizManager.tryAgainRemainCount)回)") {
                        quizManager.isTryAgainTriggered = true
                        quizManager.isShowAnswerView = false
                        navigationManager.path.removeLast()
                    }
                    .disabled(quizManager.tryAgainRemainCount < 1)
                }
                if quizManager.isShowMaruBatsu {
                    Image(systemName: quizManager.isAnswerCorrect ? "circle.circle" : "multiply")
                        .resizable()
                        .frame(width: 300, height: 300)
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
