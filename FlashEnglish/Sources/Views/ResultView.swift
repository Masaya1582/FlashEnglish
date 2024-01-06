//
//  ResultView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var quizManager: QuizManager
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        NavigationView {
            VStack {
                Text("Result: \(quizManager.correctCount)問正解")
                    .modifier(CustomLabel(foregroundColor: .black, size: 24))
                Spacer()
                Button("Back") {
                    quizManager.resetAllQuiz()
                    navigationManager.path.removeAll()
                }
                .modifier(CustomButton(foregroundColor: .white, backgroundColor: .orange))
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
            .environmentObject(QuizManager())
            .environmentObject(NavigationManager())
    }
}
