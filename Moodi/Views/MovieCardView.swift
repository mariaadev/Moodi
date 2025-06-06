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
            Image(movie.imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .frame(height: 400)
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

#Preview {
    MovieCardView(movie: Movie.example)
}
