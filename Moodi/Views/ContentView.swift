//
//  ContentView.swift
//  Moodi
//
//  Created by Maria Amzil on 7/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .intro:
                IntroScreen {
                    appState.completeIntro()
                }
                .transition(.opacity)
            case .main:
                RootView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: appState.currentScreen)
    }
}
