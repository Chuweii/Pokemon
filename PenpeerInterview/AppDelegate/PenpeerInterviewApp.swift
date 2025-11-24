//
//  PenpeerInterviewApp.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import SwiftUI

@main
struct PenpeerInterviewApp: App {
    var body: some Scene {
        WindowGroup {
            HomeViewControllerWrapper()
        }
    }
}

struct HomeViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No update needed
    }
}
