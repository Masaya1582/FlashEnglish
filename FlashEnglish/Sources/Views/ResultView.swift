//
//  ResultView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/05.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct ResultView: View {

    var body: some View {
        NavigationView {
            VStack {
                Button("Back") {
                    // Topに戻る
                }
                .modifier(CustomButton(foregroundColor: .white, backgroundColor: .orange))
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
