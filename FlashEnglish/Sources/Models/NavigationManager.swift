//
//  NavigationManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/06.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI

enum ViewType: Hashable {
    case homeView
    case quizDetailView
    case quizView
    case answerView
    case answerDetailView
    case resultView
}

final class NavigationManager: ObservableObject {
    @Published var path: [ViewType] = []
}
