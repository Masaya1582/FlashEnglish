//
//  SideMenuManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import Foundation

enum SideMenuManager: Int, CaseIterable {
    case home
    case developer

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .developer:
            return "開発者"
        }
    }

    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .developer:
            return "iphone"
        }
    }
}
