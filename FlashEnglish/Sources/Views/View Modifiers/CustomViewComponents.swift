//
//  CustomViewComponents.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/04.
//

import SwiftUI

/// カスタムLabel
struct CustomLabel: ViewModifier {
    let foregroundColor: Color
    let size: CGFloat
    let fontName: FontConvertible

    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: size))
            .foregroundColor(foregroundColor)
    }
}

/// カスタムButton
struct CustomButton: ViewModifier {
    let foregroundColor: Color
    let backgroundColor: Color
    let fontName: FontConvertible

    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: 24))
            .frame(width: 280, height: 24, alignment: .center)
            .padding()
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .padding()
    }
}

/// カスタムTextField
struct CustomTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.NotoSans.regular, size: 16))
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
            )
            .padding()
    }
}

/// カスタムImage
struct CustomImage: ViewModifier {
    let width: CGFloat
    let height: CGFloat

    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}
