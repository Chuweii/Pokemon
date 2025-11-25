//
//  PenpeerInterviewApp.swift
//  PenpeerInterview
//
//  Created by Wei Chu on 2025/11/24.
//

import SwiftUI
import Pokemon

@main
struct PenpeerInterviewApp: App {
    init() {
        setupNavigationAppearance()
    }

    var body: some Scene {
        WindowGroup {
            HomeViewControllerWrapper()
                .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                .ignoresSafeArea()
        }
    }
    
    private func setupNavigationAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground
        appearance.shadowColor = .clear // Remove the separator line
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
