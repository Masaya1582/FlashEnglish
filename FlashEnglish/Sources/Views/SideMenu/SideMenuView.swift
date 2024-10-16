//
//  SideMenuView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
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
                    .fill(Asset.Colors.defaultWhite.swiftUIColor)
                    .frame(width: 270)
                VStack(alignment: .leading, spacing: 0) {
                    profileImageView()
                        .frame(height: 140)
                        .padding(.bottom, 30)
                    ForEach(SideMenuManager.allCases, id: \.self) { row in
                        rowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.sideMenuIcon, title: row.sideMenuTitle) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(
                    Asset.Colors.defaultWhite.swiftUIColor
                )
            }
            Spacer()
        }
        .background(.clear)
    }

    @ViewBuilder
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
                .modifier(CustomLabel(foregroundColor: Asset.Colors.defaultBlack.swiftUIColor, size: 18, fontName: FontFamily.NotoSans.bold))

            Text("iOSエンジニア")
                .modifier(CustomLabel(foregroundColor: Asset.Colors.defaultBlack.swiftUIColor.opacity(0.5), size: 14, fontName: FontFamily.NotoSans.bold))
        }
    }

    @ViewBuilder
    private func rowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (() -> Void)) -> some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    Rectangle()
                        .fill(isSelected ? Asset.Colors.buttonColor.swiftUIColor : Asset.Colors.defaultWhite.swiftUIColor)
                        .frame(width: 5)
                    ZStack {
                        Image(systemName: imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? Asset.Colors.defaultBlack.swiftUIColor : Asset.Colors.gray4.swiftUIColor)
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
            LinearGradient(colors: [isSelected ? Asset.Colors.buttonColor.swiftUIColor : Asset.Colors.defaultWhite.swiftUIColor, Asset.Colors.defaultWhite.swiftUIColor], startPoint: .leading, endPoint: .trailing)
        )
    }

}

// MARK: - Preview
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(selectedSideMenuTab: .constant(0), presentSideMenu: .constant(false))
    }
}
