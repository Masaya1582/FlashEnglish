//
//  DeveloperView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

struct DeveloperView: View {
    @State private var isShowWebView = false
    @Binding var presentSideMenu: Bool
    private let iconItemArray: [Icon] = [
        Icon(image: Asset.Assets.imgX.swiftUIImage, url: URL(string: "https://twitter.com/TaroTaro2025/")),
        Icon(image: Asset.Assets.imgInstagram.swiftUIImage, url: URL(string: "https://www.instagram.com/cookie_ios_developer/")),
        Icon(image: Asset.Assets.imgBlog.swiftUIImage, url: URL(string: "https://masasophi.com/")),
        Icon(image: Asset.Assets.imgGithub.swiftUIImage, url: URL(string: "https://github.com/Masaya1582"))
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Asset.Assets.imgProfile.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
                Text("Masaya Nakakuki")
                    .modifier(CustomLabel(foregroundColor: .black, size: 32, fontName: FontFamily.NotoSans.bold))
                Text("iOSエンジニア")
                    .modifier(CustomLabel(foregroundColor: .black, size: 24, fontName: FontFamily.NotoSans.semiBold))
                Text(L10n.developerDescription)
                    .modifier(CustomLabel(foregroundColor: .black, size: 16, fontName: FontFamily.NotoSans.regular))
                    .padding()
                HStack(spacing: 24) {
                    ForEach(iconItemArray) { icon in
                        Button {
                            // FIXME: SafariViewを使いたい
                            guard let url = icon.url else { return }
                            UIApplication.shared.open(url)
                        } label: {
                            icon.image
                                .resizable()
                                .modifier(CustomImage(width: 60, height: 60))
                        }
                    }
                }
            }
            .navigationBarItems(
                leading:
                    Button {
                        presentSideMenu.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.black)
                    }
            )
        }
    }
}

// MARK: - Preview
struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView(presentSideMenu: .constant(false))
    }
}