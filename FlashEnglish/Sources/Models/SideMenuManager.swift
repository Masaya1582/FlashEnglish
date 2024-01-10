//
//  SideMenuManager.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import Foundation
import SwiftUI

enum SideMenuManager: Int, CaseIterable {
    case home
    case developer

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .developer:
            return "開発者を知る"
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

struct IconImage: Identifiable {
    let id = UUID()
    let image: Image
    let url: URL?
}
