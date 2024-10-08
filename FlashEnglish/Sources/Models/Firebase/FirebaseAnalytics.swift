//
//  FirebaseAnalytics.swift
//  FlashEnglish
//
//  Created by MasayaNakakuki on 2024/10/06.
//

import Firebase

enum FirebaseAnalytics {
    // MARK: - Tracking
    static func logEvent(_ event: Event) {
        Firebase.Analytics.logEvent(
            event.name,
            parameters: event.parameters?.compactMapValues { $0 }
        )
    }

    // MARK: - Event
    enum Event {
        case eventOne
        case eventTwo
        case eventThree
        case selectedLevel(String) // パラメータ付きイベント

        // MARK: - Name
        var name: String {
            switch self {
            case .eventOne:
                return "event_ones"
            case .eventTwo:
                return "event_two"
            case .eventThree:
                return "event_three"
            case .selectedLevel:
                return "selected_level"
            }
        }

        // MARK: - Parameters
        var parameters: [String: Any?]? {
            switch self {
            case .eventOne,
                    .eventTwo,
                    .eventThree:
                return nil
            case let .selectedLevel(parameter):
                return ["parameter": parameter]
            }
        }
    }
}
