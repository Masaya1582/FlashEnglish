//
//  TabItemView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
//

import SwiftUI

/// 各タブアイテムのView
struct TabItemView: View {
    // MARK: - Properties
    @Binding var presentSideMenu: Bool
    let title: String

    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentSideMenu.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Asset.Colors.defaultBlack.swiftUIColor)
                }
                Spacer()
            }
            Spacer()
            Text(title)
                .modifier(CustomLabel(foregroundColor: Asset.Colors.defaultBlack.swiftUIColor, size: 32, fontName: FontFamily.NotoSansJP.medium))
            Spacer()
        }
    }
}
