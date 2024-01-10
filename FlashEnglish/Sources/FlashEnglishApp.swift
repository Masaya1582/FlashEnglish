//
//  FlashEnglishApp.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/04.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

@main
struct FlashEnglishApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State static var presentSideMenu = false
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(QuizManager())
                .environmentObject(NavigationManager())
        }
    }
}
