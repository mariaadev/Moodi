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

    private let apiKey = Secrets.tmdbApiKey
    private let baseURL = "https://api.themoviedb.org/3"
    
    init() {
        likedMovies = UserDefaults.standard.loadLikedMovies()
        dislikedMovies = UserDefaults.standard.loadDislikedMovies()
    }

    func swipeRight(movie: Movie) {
        likedMovies.append(movie)
        UserDefaults.standard.saveLikedMovies(likedMovies)
        removeMovie(movie)
    }

    func swipeLeft(movie: Movie) {
        dislikedMovies.append(movie)
        UserDefaults.standard.saveDislikedMovies(dislikedMovies)
        removeMovie(movie)
    }

    private func removeMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
    }

    func loadMovies(for mood: Mood) {
        let genreIds = mood.genres.compactMap { genreNameToId[$0] }
        let genresString = genreIds.map(String.init).joined(separator: ",")
        guard let url = URL(string: "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=\(genresString)") else {
               print("URL inválida")
               return
           }

           URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else {
                   print("Error al obtener películas: \(error?.localizedDescription ?? "Desconocido")")
                   return
               }

               do {
                   let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                   DispatchQueue.main.async {
                       self.movies = decoded.results.map { apiMovie in
                           Movie(
                               id: UUID(),
                               title: apiMovie.title,
                               synopsis: apiMovie.overview,
                               posterURL: nil
                           )
                       }
                   }
               } catch {
                   print("Error al decodificar JSON: \(error)")
               }
           }.resume()
       }
}
