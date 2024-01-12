//
//  SideMenuView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct SideMenuView: View {
    // MARK: - Properties
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool

    // MARK: - Body
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                VStack(alignment: .leading, spacing: 0) {
                    profileImageView()
                        .frame(height: 140)
                        .padding(.bottom, 30)
                    ForEach(SideMenuManager.allCases, id: \.self) { row in
                        rowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(
                    Color.white
                )
            }
            Spacer()
        }
        .background(.clear)
    }

    private func profileImageView() -> some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Asset.Assets.imgProfile.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Asset.Colors.gray5.swiftUIColor, lineWidth: 1)
                    )
                    .cornerRadius(50)
                Spacer()
            }

            Text("Masaya Nakakuki")
                .modifier(CustomLabel(foregroundColor: .black, size: 18, fontName: FontFamily.NotoSans.bold))

            Text("iOSエンジニア")
                .modifier(CustomLabel(foregroundColor: .black, size: 14, fontName: FontFamily.NotoSans.bold))
                .foregroundColor(.black.opacity(0.5))
        }
    }

    private func rowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (() -> Void)) -> some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    Rectangle()
                        .fill(isSelected ? Asset.Colors.buttonColor.swiftUIColor : .white)
                        .frame(width: 5)
                    ZStack {
                        Image(systemName: imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? .black : .gray)
                            .frame(width: 24, height: 24)
                    }
                    Text(title)
                        .modifier(CustomLabel(foregroundColor: isSelected ? Asset.Colors.gray1.swiftUIColor : Asset.Colors.gray5.swiftUIColor, size: 14, fontName: FontFamily.NotoSans.bold))
                    Spacer()
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height / 12)
        .background(
            LinearGradient(colors: [isSelected ? Asset.Colors.buttonColor.swiftUIColor : .white, .white], startPoint: .leading, endPoint: .trailing)
        )
    }

}

// MARK: - Preview
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(selectedSideMenuTab: .constant(0), presentSideMenu: .constant(false))
    }
}
