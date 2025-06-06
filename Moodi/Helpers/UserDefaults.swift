//
//  UserDefaults.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let likedMovies = "likedMovies"
        static let dislikedMovies = "dislikedMovies"
    }

    func saveMovies(_ movies: [Movie], forKey key: String) {
        if let data = try? JSONEncoder().encode(movies) {
            set(data, forKey: key)
        }
    }

    func loadMovies(forKey key: String) -> [Movie] {
        if let data = data(forKey: key),
           let movies = try? JSONDecoder().decode([Movie].self, from: data) {
            return movies
        }
        return []
    }

    func saveLikedMovies(_ movies: [Movie]) {
        saveMovies(movies, forKey: Keys.likedMovies)
    }

    func saveDislikedMovies(_ movies: [Movie]) {
        saveMovies(movies, forKey: Keys.dislikedMovies)
    }

    func loadLikedMovies() -> [Movie] {
        loadMovies(forKey: Keys.likedMovies)
    }

    func loadDislikedMovies() -> [Movie] {
        loadMovies(forKey: Keys.dislikedMovies)
    }
}
