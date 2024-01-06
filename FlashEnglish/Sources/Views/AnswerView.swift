//
//  AnswerView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct AnswerView: View {
    @State private var answer = ""
    @Binding var tryAgainCount: Int
    @State private var userAnswer: [String] = []
    @State private var alertTitle = ""
    @Binding var correctAnswer: [String]
    @Binding var isTryOneMore: Bool
    @Binding var isShowAnswerView: Bool
    @State private var isShowDescriptionModalView = false
    @State private var isAnswerCorrect = false
    @State private var isShowMaruBatsu = false

    var body: some View {
        NavigationView {
            ZStack {
                if isShowDescriptionModalView {
                    AnswerDetailView(correctAnswer: $correctAnswer, isAnswerCorrect: $isAnswerCorrect)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .zIndex(1)
                }
                VStack(spacing: 28) {
                    Text("解答")
                        .modifier(CustomLabel(foregroundColor: .black, size: 32))
                    TextField("正しい順番に並び替えよう", text: $answer)
                        .modifier(CustomTextField())
                    Button("GO") {
                        userAnswer = answer.components(separatedBy: " ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        isShowMaruBatsu = true
                        if userAnswer == correctAnswer {
                            isAnswerCorrect = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isShowMaruBatsu = false
                            isShowDescriptionModalView = true
                        }
                    }
                    .modifier(CustomButton(foregroundColor: .white, backgroundColor: .orange))
                    Button("もう一度みる (あと\(tryAgainCount)回)") {
                        isTryOneMore = true
                        isShowAnswerView = false
                    }
                    .disabled(tryAgainCount < 1)
                }
                if isShowMaruBatsu {
                    Image(systemName: isAnswerCorrect ? "circle.circle" : "multiply")
                        .resizable()
                        .frame(width: 300, height: 300)
                }
            }
        }
        .onDisappear {
            isTryOneMore = false
        }
        .navigationBarBackButtonHidden()
    }
}

struct AnswerView_Previews: PreviewProvider {
    @State static var correctAnswer: [String] = []
    @State static var isTryOneMore = false
    @State static var isShowAnswerView = false
    @State static var tryAgainCount = 0
    static var previews: some View {
        AnswerView(tryAgainCount: $tryAgainCount, correctAnswer: $correctAnswer, isTryOneMore: $isTryOneMore, isShowAnswerView: $isShowAnswerView)
    }
}
