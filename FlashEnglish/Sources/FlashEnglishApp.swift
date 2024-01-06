//
//  FlashEnglishApp.swift
//  FlashEnglish
//
//  Created by MasayaNakakuki on 2024/01/04.
//

import SwiftUI

@main
struct FlashEnglishApp: App {
    @State static var isSetNextQuiz = false
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(QuizManager())
                .environmentObject(NavigationManager())
        }
    }
}
