//
//  SavedMoviesView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct SavedMoviesView: View {
    @ObservedObject var viewModel: MovieViewModel
    var body: some View {
        NavigationView {
                   List {
                       Section(header: Text("Liked Movies")) {
                           ForEach(viewModel.likedMovies) { movie in
                               Text(movie.title)
                           }
                       }

                       Section(header: Text("Disliked Movies")) {
                           ForEach(viewModel.dislikedMovies) { movie in
                               Text(movie.title)
                           }
                       }
                   }
                   .navigationTitle("Saved Movies")
               }
    }
}

#Preview {
    SavedMoviesView(viewModel: MovieViewModel())
}
