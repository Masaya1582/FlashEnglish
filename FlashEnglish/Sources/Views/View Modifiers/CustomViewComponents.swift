//
//  CustomViewComponents.swift
//  FlashEnglish
//
//  Created by MasayaNakakuki on 2024/01/04.
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

/// 伸び縮みするButton
struct StretchableButton: ButtonStyle {
    let foregroundColor: Color
    let backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom(FontFamily.Caprasimo.regular, size: 24))
            .frame(width: UIScreen.main.bounds.width / 1.6, height: UIScreen.main.bounds.height / 28, alignment: .center)
            .padding()
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 27))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

/// カスタムTextField
struct CustomTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FontFamily.Caprasimo.regular, size: 16))
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
            )
            .padding()
    }
}


