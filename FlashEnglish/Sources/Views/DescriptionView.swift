//
//  DescriptionView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct DescriptionView: View {
    @State var dismissAction: (() -> Void)
    @Binding var correctAnswer: [String]
    @State private var formattedCorrectAnswer = ""
    @State private var isTryNextQuiz = false
    @State private var isSetNextQuiz = false

    var body: some View {
        NavigationLink(destination: HomeView(isSetNextQuiz: $isSetNextQuiz), isActive: $isTryNextQuiz) {
            VStack {
                modalView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 32)
            .padding(12)
            .background(
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
            )
            .onAppear {
                formattedCorrectAnswer = correctAnswer.joined(separator: ",")
                formattedCorrectAnswer = formattedCorrectAnswer.replacingOccurrences(of: ",", with: " ")
            }
        }
    }

    var modalView: some View {
        VStack(spacing: 42) {
            Text("Answer")
                .font(.system(size: 28))
            Text(formattedCorrectAnswer)
                .font(.system(size: 28))
            nextQuizButton
        }
        .padding(20)
        .background(.white)
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
    }

    var nextQuizButton: some View {
        Button(action: {
            isTryNextQuiz = true
            isSetNextQuiz = true
        }, label: {
            Text("Next")
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .background(.orange)
        .cornerRadius(80)
        .frame(height: 60)
    }
}

struct DescriptionView_Previews: PreviewProvider {
    @State static var correctAnswer = ["This", "is", "a", "pen"]
    static var previews: some View {
        DescriptionView(dismissAction: {}, correctAnswer: $correctAnswer)
    }
}
