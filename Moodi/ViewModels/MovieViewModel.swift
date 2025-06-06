//
//  MovieViewModel.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import Foundation

class MovieViewModel : ObservableObject {
    @Published var movies: [Movie] = []
    @Published var likedMovies: [Movie] = []
    @Published var dislikedMovies: [Movie] = []

    init() {
        loadMockMovies()
    }

    func swipeRight(movie: Movie) {
        likedMovies.append(movie)
        removeMovie(movie)
    }

    func swipeLeft(movie: Movie) {
        dislikedMovies.append(movie)
        removeMovie(movie)
    }

    private func removeMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
    }

    private func loadMockMovies() {
        movies = [
            Movie(id: UUID(), title: "Inception", synopsis: "A dream within a dream.", imageName: "inception"),
            Movie(id: UUID(), title: "Interstellar", synopsis: "Exploring black holes and time.", imageName: "interstellar"),
            Movie(id: UUID(), title: "Memento", synopsis: "A man with no short-term memory hunts for his wife's killer—one clue at a time.", imageName: "memento")
         ]
    }
}
