//
//  QuizLevelGridItem.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  

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
                .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 6)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )

            Text(levelItem.title)
                .modifier(CustomLabel(foregroundColor: Asset.Colors.black.swiftUIColor, size: 16, fontName: FontFamily.NotoSansJP.semiBold))
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
