//
//  MovieCardView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct MovieCardView: View {
    let movie : Movie
    @State private var showDetails = false
    
    var body: some View {
        VStack {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 301, height: 400)
                    .clipped()
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                } else {
                    Color.gray.opacity(0.3)
                        .frame(width: 301, height: 400)
                        .cornerRadius(10, corners: [.topLeft, .topRight])
                }

            VStack(alignment: .leading, spacing: 8) {
                           Text(movie.title)
                               .font(.title3)
                               .bold()
                           
                           Text(movie.synopsis)
                               .font(.body)
                               .lineLimit(3)
                           
                           Button(action: {
                               showDetails = true
                           }) {
                               Text("Read more")
                                   .font(.caption)
                                   .foregroundColor(Color.primaryColor)
                                   .padding(.top, 4)
                           }
                           .sheet(isPresented: $showDetails) {
                               //MovieDetailView(movie: movie)
                           }
                       }
                       .padding()
                       .frame(width: 301, height: 151, alignment: .topLeading)
                       .background(Color.gray.opacity(0.1))
                       .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            }
            .frame(width: 301, height: 551)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
    }
}

#Preview {
    MovieCardView(movie: Movie(
        id: 1,
        title: "Inception",
        synopsis: "A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.",
        posterURL: URL(string: "https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg")
    ))
}
