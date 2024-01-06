//
//  FlashEnglishApp.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/04.
//

import SwiftUI

@main
struct FlashEnglishApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(QuizManager())
                .environmentObject(NavigationManager())
        }
    }
}
