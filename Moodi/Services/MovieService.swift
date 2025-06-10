//
//  MovieService.swift
//  Moodi
//
//  Created by Maria Amzil on 10/6/25.
//

import Foundation

class MovieService {
    private let apiKey = Secrets.tmdbApiKey
    private let baseURL = "https://api.themoviedb.org/3"
    private let posterBaseURL = "https://image.tmdb.org/t/p/w500"

    func fetchMovies(for mood: Mood, page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let genreIds = mood.genres.compactMap { genreNameToId[$0] }
        let genresString = genreIds.map(String.init).joined(separator: ",")

        let sortOptions = ["popularity.desc", "vote_average.desc", "release_date.desc"]
        let selectedSort = sortOptions.randomElement() ?? "popularity.desc"

        guard let url = URL(string: "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=\(genresString)&sort_by=\(selectedSort)&page=\(page)&vote_count.gte=100") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -2)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func transformToMovies(_ apiMovies: [APIMovie], excludingIds: Set<Int>) -> [Movie] {
        apiMovies.compactMap { apiMovie in
            guard !excludingIds.contains(apiMovie.id),
                  !apiMovie.overview.isEmpty,
                  let posterPath = apiMovie.poster_path,
                  let posterURL = URL(string: posterBaseURL + posterPath) else {
                return nil
            }

            let genres = apiMovie.genre_ids.compactMap { genreIdToName[$0] }

            return Movie(
                id: apiMovie.id,
                title: apiMovie.title,
                synopsis: apiMovie.overview,
                posterURL: posterURL,
                genres: genres
            )
        }
    }
}
