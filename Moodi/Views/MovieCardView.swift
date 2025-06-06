//
//  MovieCardView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct MovieCardView: View {
    let movie : Movie
    
    var body: some View {
        VStack {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .scaledToFit()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .cornerRadius(10)
                    .frame(height: 400)
                } else {
                    Color.gray.opacity(0.3)
                        .frame(height: 400)
                        .cornerRadius(10)
                }

                Text(movie.title)
                    .font(.title)
                    .bold()
                Text(movie.synopsis)
                    .font(.body)
                    .padding()
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
        }
}

