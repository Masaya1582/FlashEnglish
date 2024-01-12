//
//  AdMobBannerView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/08.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI
import GoogleMobileAds

struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3728831230250514/8345583201" // Prod
        // bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // TEST
        let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        bannerView.rootViewController = windowScenes?.keyWindow?.rootViewController
        bannerView.load(GADRequest())
        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}
