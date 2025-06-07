//
//  MoodiApp.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

@main
struct MoodiApp: App {
    @State private var isSplashActive = true
    @AppStorage("hasSeenIntro") var hasSeenIntro: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashActive {
                    SplashView()
                } else if !hasSeenIntro {
                    IntroScreen()
                } else {
                    RootView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isSplashActive = false
                    }
                }
            }
        }
    }
}
