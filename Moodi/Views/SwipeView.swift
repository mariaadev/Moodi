//
//  SwipeView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct SwipeView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var selectedMood: Mood?
    
    var body: some View {
        VStack {
            HStack {
                Text("Mood: \(selectedMood?.rawValue.capitalized ?? "")")
                    .font(.headline)
                Spacer()
                Button("Change Mood") {
                    selectedMood = nil
                }
            }
            .padding()
            ZStack {
                ForEach(viewModel.movies.reversed()) { movie in
                    MovieCardView(movie: movie)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width > 100 {
                                        viewModel.swipeRight(movie: movie)
                                    } else if value.translation.width < -100{
                                        viewModel.swipeLeft(movie: movie)
                                    }
                                }
                        )
                        .animation(.spring(), value: viewModel.movies)
                }
            }
        }
    }
}



