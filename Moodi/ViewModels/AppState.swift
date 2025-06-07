//
//  AppState.swift
//  Moodi
//
//  Created by Maria Amzil on 7/6/25.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @AppStorage("hasSeenIntro") var hasSeenIntro: Bool = false
    
    init() {
        startSplash()
    }
    
    func startSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.currentScreen = self.hasSeenIntro ? .main : .intro
            }
        }
    }
    
    func completeIntro() {
        withAnimation(.easeInOut) {
            hasSeenIntro = true
            currentScreen = .main
        }
    }
}
