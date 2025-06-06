//
//  MainTabView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var selectedMood: Mood?
    
    var body: some View {
        TabView {
            SwipeView(viewModel: viewModel, selectedMood: $selectedMood)
                .tabItem {
                    Label("Discover", systemImage: "film")
                }
            SavedMoviesView(viewModel: viewModel)
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
    }
}

#Preview {
    StatefulPreviewWrapper<Mood?, MainTabView>(initialValue: Mood?.some(.happy)) { moodBinding in
        MainTabView(viewModel: MovieViewModel(), selectedMood: moodBinding)
    }
}
