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
                            .font(.custom("Poppins-Medium", size:16))
                            .foregroundColor(Color.textColor)
                           
                           Text(movie.synopsis)
                            .font(.custom("Poppins-Light", size:12))
                            .lineLimit(4)
                            .foregroundColor(Color.textColor)
                           
                           Button(action: {
                               showDetails = true
                           }) {
                               Text("Read more")
                                   .font(.custom("Poppins-Light", size:10))
                                   .foregroundColor(.blue)
                                   .padding(.top, 4)
                           }
                           .sheet(isPresented: $showDetails) {
                               MovieDetailView(movieId: movie.id)
                           }
                       }
                       .padding()
                       .frame(width: 301, height: 151, alignment: .topLeading)
                       .background(Color.terciaryColor.opacity(0.1))
                       .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            }
            .frame(width: 301, height: 551)
            .background(Color.terciaryColor)
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
        posterURL: URL(string: "https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg"), genres: nil
    ))
}
