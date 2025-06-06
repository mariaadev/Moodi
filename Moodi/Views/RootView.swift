//
//  RootView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct RootView: View {
    @State private var selectedMood: Mood? = nil
    @StateObject private var viewModel = MovieViewModel()
       
    var body: some View {
        Group {
            if let mood = selectedMood {
                MainTabView(viewModel: viewModel, selectedMood: $selectedMood)
                    .onAppear {
                        viewModel.loadMovies(for: mood)
                    }
            } else {
                MoodSelectionView(selectedMood: $selectedMood)
            }
        }
    }
}

#Preview {
    RootView()
}
