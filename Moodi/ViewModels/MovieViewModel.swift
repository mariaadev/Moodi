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
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private var currentMood: Mood?
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isLoadingInProgress: Bool = false
    
    private var allSeenMovieIds: Set<Int> = []
    
    private let apiKey = Secrets.tmdbApiKey
    private let baseURL = "https://api.themoviedb.org/3"
    
    init() {
        likedMovies = UserDefaults.standard.loadLikedMovies()
        dislikedMovies = UserDefaults.standard.loadDislikedMovies()
        
        allSeenMovieIds = Set(likedMovies.map { $0.id } + dislikedMovies.map { $0.id })
    }

    func swipeRight(movie: Movie) {
        likedMovies.append(movie)
        UserDefaults.standard.saveLikedMovies(likedMovies)
        removeMovie(movie)
        checkAndLoadMoreMovies()
    }

    func swipeLeft(movie: Movie) {
        dislikedMovies.append(movie)
        UserDefaults.standard.saveDislikedMovies(dislikedMovies)
        removeMovie(movie)
        checkAndLoadMoreMovies()
    }

    private func removeMovie(_ movie: Movie) {
        DispatchQueue.main.async { [weak self] in
                   self?.movies.removeAll { $0.id == movie.id }
        }
    }
    
    private func checkAndLoadMoreMovies() {
           if movies.count <= 3 && !isLoadingInProgress {
               loadMoreMovies()
           }
    }
    
    private func loadMoreMovies() {
          guard let mood = currentMood,
                !isLoadingMore,
                !isLoadingInProgress,
                currentPage < totalPages else { return }
          
          isLoadingMore = true
          isLoadingInProgress = true
          currentPage += 1
          
          loadMoviesFromAPI(mood: mood, page: currentPage, isInitialLoad: false)
      }
    
    private func loadMoviesFromAPI(mood: Mood, page: Int, isInitialLoad: Bool) {
            let genreIds = mood.genres.compactMap { genreNameToId[$0] }
            let genresString = genreIds.map(String.init).joined(separator: ",")
            
            let sortOptions = ["popularity.desc", "vote_average.desc", "release_date.desc"]
            let selectedSort = sortOptions.randomElement() ?? "popularity.desc"
            
            guard let url = URL(string: "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=\(genresString)&sort_by=\(selectedSort)&page=\(page)&vote_count.gte=100") else {
                print("URL inválida")
                finishLoading(isInitialLoad: isInitialLoad)
                return
            }

            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                guard let data = data, error == nil else {
                    print("Error al obtener películas: \(error?.localizedDescription ?? "Desconocido")")
                    DispatchQueue.main.async {
                        self.finishLoading(isInitialLoad: isInitialLoad)
                    }
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.processNewMovies(decoded, isInitialLoad: isInitialLoad)
                    }
                } catch {
                    print("Error al decodificar JSON: \(error)")
                    DispatchQueue.main.async {
                        self.finishLoading(isInitialLoad: isInitialLoad)
                    }
                }
            }.resume()
        }
    
    private func finishLoading(isInitialLoad: Bool) {
           isLoadingInProgress = false
           if isInitialLoad {
               isLoading = false
           } else {
               isLoadingMore = false
           }
       }
       
       func resetForNewMood() {
           movies.removeAll()
           currentPage = 1
           totalPages = 1
           currentMood = nil
       }
    
    private func processNewMovies(_ response: MovieResponse, isInitialLoad: Bool) {
           totalPages = min(response.total_pages ?? 500, 500)
           
           let posterBaseURL = "https://image.tmdb.org/t/p/w500"
           let newMovies = response.results.compactMap { apiMovie -> Movie? in
               guard !allSeenMovieIds.contains(apiMovie.id),
                     !apiMovie.overview.isEmpty,
                     apiMovie.poster_path != nil else { return nil }
               
               let posterURL = URL(string: posterBaseURL + apiMovie.poster_path!)
               return Movie(
                   id: apiMovie.id,
                   title: apiMovie.title,
                   synopsis: apiMovie.overview,
                   posterURL: posterURL
               )
           }
           
           if isInitialLoad {
               self.movies = newMovies.shuffled()
           } else {
               let combinedMovies = self.movies + newMovies
               self.movies = combinedMovies.shuffled()
           }
           
           finishLoading(isInitialLoad: isInitialLoad)
           
           if newMovies.count < 10 && currentPage < totalPages {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   self.loadMoreMovies()
               }
           }
       }

    func loadMovies(for mood: Mood) {
           guard !isLoading else { return }
           
           currentMood = mood
           currentPage = 1
           totalPages = 1
           isLoading = true
           isLoadingInProgress = true
           
           loadMoviesFromAPI(mood: mood, page: 1, isInitialLoad: true)
       }
}
