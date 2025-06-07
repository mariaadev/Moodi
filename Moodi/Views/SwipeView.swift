//
//  SwipeView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct SwipeView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var selectedMood: Mood?
    @State private var showingSelection = false
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                   .ignoresSafeArea()
            VStack {
                HStack {
                   
                    Button(action: {
                            selectedMood = nil
                       }) {
                           Text("Mood")
                               .font(.custom("Poppins-Medium", size: 16))
                               .frame(width: 80, height: 40)
                               .foregroundColor(Color.white)
                               .background(Color.primaryColor)
                               .cornerRadius(10)
                       }
                      
                       Spacer()
                       Text(selectedMood?.rawValue.capitalized ?? "No Mood")
                           .font(.custom("Poppins-Medium", size: 16))
                           .frame(width: 124, height: 40)
                           .background(Color.terciaryColor)
                           .foregroundColor(Color.textColor)
                           .cornerRadius(10)
                           .padding(.leading, 10)
                   
                }
                .padding()
                ZStack {
                    ForEach(viewModel.movies.reversed()) { movie in
                        MovieCardView(movie: movie)
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        if value.translation.width > 100 {
                                            viewModel.swipeRight(movie: movie)
                                        } else if value.translation.width < -100{
                                            viewModel.swipeLeft(movie: movie)
                                        }
                                    }
                            )
                            .animation(.spring(), value: viewModel.movies)
                    }
                }
            }
        }
    }
}



#Preview {
    StatefulPreviewWrapper<Mood?, SwipeView>(initialValue: .some(.happy)) { moodBinding in
        SwipeView(viewModel: MovieViewModel(), selectedMood: moodBinding)
    }
}
