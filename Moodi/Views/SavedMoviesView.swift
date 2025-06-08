//
//  SavedMoviesView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct SavedMoviesView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var showingResetAlert = false
    @State private var selectedMood: Mood? = nil
    @State private var selectedMovie: Movie? = nil

    private let columns = [
          GridItem(.flexible()),
          GridItem(.flexible())
    ]
      
    var filteredMovies: [Movie] {
           guard let selectedMood = selectedMood else {
               return viewModel.likedMovies
           }
           
           return viewModel.likedMovies.filter { movie in
               guard let movieGenres = movie.genres else { return false }
               return selectedMood.genres.contains { moodGenre in
                   movieGenres.contains(moodGenre)
               }
           }
       }
    
    var body: some View {
        NavigationView {
                    VStack(alignment: .leading, spacing: 0) {
                        headerView
                        moodFilterView
                        movieGridView
                    }
                    .background(Color.black)
                    .navigationBarHidden(true)
                }
                .sheet(item: $selectedMovie) { movie in
                    MovieDetailView(movieId: movie.id)
                }

                .alert("Reset Liked Movies", isPresented: $showingResetAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Reset", role: .destructive) {
                        viewModel.resetLikedMovies()
                    }
                } message: {
                    Text("Are you sure you want to remove all liked movies? This action cannot be undone.")
                }
            }
            
            private var headerView: some View {
                HStack {
                    HStack {
                        Circle()
                            .fill(Color.primaryColor)
                            .frame(width: 24, height: 24)
                        Text("My List")
                            .font(.custom("Poppins-Medium", size:26))
                            .fontWeight(.medium)
                            .foregroundColor(Color.textColor)
                    }
                    
                    Spacer()
                    
                    Button("Reset") {
                        if !viewModel.likedMovies.isEmpty {
                            showingResetAlert = true
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .foregroundColor(Color.textColor)
                    .background(Color.terciaryColor)
                    .cornerRadius(18)
                    .font(.custom("Poppins-Medium", size:14))
                    .disabled(viewModel.likedMovies.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            
            private var moodFilterView: some View {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        allMoodsButton
                        
                        ForEach(Mood.allCases) { mood in
                            moodButton(for: mood)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 16)
            }
            
            private var allMoodsButton: some View {
                Button("All Moods") {
                    selectedMood = nil
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(moodButtonBackground(isSelected: selectedMood == nil))
                .foregroundColor(selectedMood == nil ? .white : Color.primaryColor)
                .font(.custom("Poppins-Medium", size:14))
            }
            
            private func moodButton(for mood: Mood) -> some View {
                Button(mood.rawValue.capitalized) {
                    selectedMood = mood
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(moodButtonBackground(isSelected: selectedMood == mood))
                .foregroundColor(selectedMood == mood ? .white : Color.primaryColor)
                .font(.custom("Poppins-Medium", size:14))
            }
            
            private func moodButtonBackground(isSelected: Bool) -> some View {
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.primaryColor : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.primaryColor, lineWidth: 2)
                    )
            }
            
            private var movieGridView: some View {
                ScrollView {
                    if filteredMovies.isEmpty {
                        emptyStateView
                    } else {
                        movieGrid
                    }
                }
            }
            
            private var emptyStateView: some View {
                VStack {
                    Spacer()
                    Text(selectedMood == nil ? "No liked movies yet" : "No movies for this mood")
                        .foregroundColor(.secondary)
                        .italic()
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 300)
            }
            
            private var movieGrid: some View {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredMovies) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                            moviePosterView(for: movie)
                          }
                          .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
    private func moviePosterView(for movie: Movie) -> some View {
        Button {
            selectedMovie = movie
        } label: {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(2/3, contentMode: .fill)
                    .overlay(
                        Text(movie.title)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(8)
                            .foregroundColor(.white)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        }
    }


#Preview {
    SavedMoviesView(viewModel: MovieViewModel())
}
