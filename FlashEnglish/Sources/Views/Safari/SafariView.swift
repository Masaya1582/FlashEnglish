//
//  SafariView.swift
//  FlashEnglish
//
//  Created by 中久木 雅哉(Nakakuki Masaya) on 2024/01/10.
//  Copyright (c) 2024 ReNKCHANNEL. All rihgts reserved.
//

import SwiftUI
import SafariServices

struct SafariView: View {
    // MARK: - Properties
    let url: URL
    let onDismiss: (() -> Void)?

    // MARK: - Body
    var body: some View {
        SafeAreaSafariView(url: url, onDismiss: onDismiss)
            .ignoresSafeArea()
    }
}

private struct SafeAreaSafariView: UIViewControllerRepresentable {
    let url: URL
    let onDismiss: (() -> Void)?

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafeAreaSafariView>) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = .done
        safariViewController.delegate = context.coordinator
        return safariViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafeAreaSafariView>) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(onDismiss: onDismiss)
    }

    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let onDismiss: (() -> Void)?

        init(onDismiss: (() -> Void)? = nil) {
            self.onDismiss = onDismiss
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            onDismiss?()
        }
    }
}
