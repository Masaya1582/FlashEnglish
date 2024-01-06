//
//  QuizDetailView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct QuizDetailView: View {
    @State private var isShowQuizView = false
    @State private var isSetNextQuiz = false
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                NavigationLink(destination: QuizView(isSetNextQuiz: $isSetNextQuiz), isActive: $isShowQuizView) {}
                Text("Easy: 5問")
                    .modifier(CustomLabel(foregroundColor: .black, size: 32))
                Text("3秒のカウント後、フラッシュ形式で問題が出題されます")
                    .modifier(CustomLabel(foregroundColor: .black, size: 20))
                    .padding()
                Spacer()
                Button("始める") {
                    isShowQuizView = true
                }
                .modifier(CustomButton(foregroundColor: .white, backgroundColor: Asset.Colors.buttonColor.swiftUIColor))
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct QuizDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QuizDetailView()
    }
}
