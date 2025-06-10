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
    private let movieService = MovieService()

    
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
        movieService.fetchMovies(for: mood, page: page) { [weak self] result in
               guard let self = self else { return }

               DispatchQueue.main.async {
                   switch result {
                   case .success(let response):
                       self.processNewMovies(response, isInitialLoad: isInitialLoad)
                   case .failure(let error):
                       print("Failed to load movies: \(error.localizedDescription)")
                       self.finishLoading(isInitialLoad: isInitialLoad)
                   }
               }
           }
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
        totalPages = min(response.total_pages , 500)
        let newMovies = movieService.transformToMovies(response.results, excludingIds: allSeenMovieIds)
        
        if isInitialLoad {
            self.movies = newMovies.shuffled()
        } else {
            self.movies += newMovies
            self.movies.shuffle()
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
    
    func resetLikedMovies() {
        let likedIds = Set(likedMovies.map { $0.id })
        likedMovies.removeAll()
        UserDefaults.standard.saveLikedMovies(likedMovies)
        allSeenMovieIds = allSeenMovieIds.subtracting(likedIds)
    }
}
