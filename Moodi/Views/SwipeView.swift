//
//  SwipeView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct SwipeView: View {
    @StateObject var viewModel = MovieViewModel()
    var body: some View {
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

#Preview {
    SwipeView()
}
