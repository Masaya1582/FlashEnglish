//
//  GridItem.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import Foundation
import SwiftUI

struct LevelItem: Identifiable {
    let id = UUID()
    let image: Image
    let title: String
    let levelCase: QuizLevel
}

struct LevelGridItem: View {
    let levelItem: LevelItem
    let tapAction: (() -> Void)

    var body: some View {
        VStack(spacing: 8) {
            levelItem.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )

            Text(levelItem.title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .onTapGesture {
            tapAction()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}
