//
//  DescriptionView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct DescriptionView: View {
    @Binding var correctAnswer: [String]
    @State private var formattedCorrectAnswer = ""
    @State private var isTryNextQuiz = false
    @State private var isSetNextQuiz = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: HomeView(isSetNextQuiz: $isSetNextQuiz), isActive: $isTryNextQuiz) {}
                modalView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 100)
            .padding(24)
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
                .modifier(CustomLabel(foregroundColor: Asset.Colors.gray3.swiftUIColor, size: 20))
            Text(formattedCorrectAnswer)
                .modifier(CustomLabel(foregroundColor: .black, size: 24))
            nextQuizButton
        }
        .padding(20)
        .background(.white)
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
    }

    var nextQuizButton: some View {
        Button("Next") {
            isTryNextQuiz = true
            isSetNextQuiz = true
        }
        .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.pink.swiftUIColor))
    }
}

struct DescriptionView_Previews: PreviewProvider {
    @State static var correctAnswer = ["This", "is", "a", "pen"]
    static var previews: some View {
        DescriptionView(correctAnswer: $correctAnswer)
    }
}
