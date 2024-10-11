//
//  DeveloperView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
//

import SwiftUI

struct DeveloperView: View {
    // MARK: - Properties
    @State private var isShowWebView = false
    @Binding var presentSideMenu: Bool
    private let socialServiceIconArray: [SocialServiceIcon] = [
        SocialServiceIcon(image: Asset.Assets.imgX.swiftUIImage, url: URL(string: "https://twitter.com/TaroTaro2025/")),
        SocialServiceIcon(image: Asset.Assets.imgInstagram.swiftUIImage, url: URL(string: "https://www.instagram.com/cookie_ios_developer/")),
        SocialServiceIcon(image: Asset.Assets.imgBlog.swiftUIImage, url: URL(string: "https://masasophi.com/")),
        SocialServiceIcon(image: Asset.Assets.imgGithub.swiftUIImage, url: URL(string: "https://github.com/Masaya1582"))
    ]

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Asset.Assets.imgProfile.swiftUIImage
                    .resizable()
                    .modifier(CustomImage(width: 200, height: 200))
                Text("Masaya Nakakuki")
                    .modifier(CustomLabel(foregroundColor: Asset.Colors.defaultBlack.swiftUIColor, size: 32, fontName: FontFamily.NotoSans.bold))
                Text("iOSエンジニア")
                    .modifier(CustomLabel(foregroundColor: Asset.Colors.defaultBlack.swiftUIColor, size: 24, fontName: FontFamily.NotoSans.semiBold))
                Text(L10n.developerDescription)
                    .modifier(CustomLabel(foregroundColor: Asset.Colors.defaultBlack.swiftUIColor, size: 16, fontName: FontFamily.NotoSans.regular))
                    .padding()
                HStack(spacing: 24) {
                    ForEach(socialServiceIconArray) { socialService in
                        Button {
                            // FIXME: - SafariViewを使いたい
                            guard let url = socialService.url else { return }
                            UIApplication.shared.open(url)
                        } label: {
                            socialService.image
                                .resizable()
                                .modifier(CustomImage(width: 60, height: 60))
                        }
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { dragValue in
                        if dragValue.translation.width > 0 && dragValue.translation.height < dragValue.translation.width {
                            presentSideMenu.toggle()
                        }
                    }
            )
            .navigationBarItems(
                leading:
                    Button {
                        presentSideMenu.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                            .foregroundColor(Asset.Colors.defaultBlack.swiftUIColor)
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
