//
//  NavigationManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  

import SwiftUI

enum ViewType: Hashable {
    case homeView
    case quizDetailView
    case quizView
    case answerView
    case answerDetailView
    case scoreView
}

final class NavigationManager: ObservableObject {
    @Published var navigationPath: [ViewType] = []
}
