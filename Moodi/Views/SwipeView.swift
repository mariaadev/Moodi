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
    @State private var dragOffset: CGSize = .zero
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.backgroundColor
                   .ignoresSafeArea()
            VStack {
                HStack(spacing: 100) {
                   
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
                      
                       Text(selectedMood?.rawValue.capitalized ?? "No Mood")
                           .font(.custom("Poppins-Medium", size: 16))
                           .frame(width: 124, height: 40)
                           .background(Color.terciaryColor)
                           .foregroundColor(Color.textColor)
                           .cornerRadius(10)
                           .padding(.leading, 10)
                   
                } .offset(y:20)
                .padding()
                ZStack {
                    ForEach(viewModel.movies.dropLast(), id: \.id) { movie in
                          MovieCardView(movie: movie)
                      }
                    if let topMovie = viewModel.movies.last {
                        MovieCardView(movie: topMovie)
                            .offset(dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                                       dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        if value.translation.width > 100 {
                                            animateSwipe(.right, topMovie)
                                        } else if value.translation.width < -100 {
                                            animateSwipe(.left, topMovie)
                                        } else {
                                            withAnimation {
                                                dragOffset = .zero
                                            }
                                        }
                                    }
                            )
                            .animation(.spring(), value: viewModel.movies)
                    }
                }
                
                HStack(spacing: 50) {
                              
                               Button(action: {
                                   if let current = viewModel.movies.last {
                                           animateSwipe(.left, current)
                                       }
                               }) {
                                   Image("cancel")
                                       .resizable()
                                       .scaledToFit()
                                       .padding(18)
                                       .frame(width: 60, height: 60)
                                       .background(Color.terciaryColor)
                                       .clipShape(Circle())
                                       .shadow(radius: 4)
                               }

                               Button(action: {
                                   if let current = viewModel.movies.last {
                                          animateSwipe(.right, current)
                                      }
                                      
                               }) {
                                   Image("heart")
                                       .resizable()
                                       .scaledToFill()
                                       .padding(15)
                                       .frame(width: 60, height: 60)
                                       .background(Color.terciaryColor)
                                       .clipShape(Circle())
                                       .shadow(radius: 4)
                               }
                }
                .offset(y: -30)
                .padding(.top, 20)
            
            }
        }
    }
    
    func animateSwipe(_ direction: SwipeDirection, _ movie: Movie) {
        guard !isAnimating else { return }
        isAnimating = true
        
        // Calcula la dirección de salida
        let exitOffset = CGSize(width: direction == .right ? 1000 : -1000, height: 0)
        
        // Aplica la animación
        withAnimation(.easeInOut(duration: 0.3)) {
            dragOffset = exitOffset
        }
        
        // Después del tiempo de animación, eliminamos la tarjeta
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Aquí eliminamos la película del arreglo
            if direction == .right {
                viewModel.swipeRight(movie: movie)
            } else {
                viewModel.swipeLeft(movie: movie)
            }
            
            // IMPORTANTE: Solo reiniciamos offset *después* de eliminar la tarjeta
            dragOffset = .zero
            isAnimating = false
        }
    }


    enum SwipeDirection {
        case left, right
    }

}



#Preview {
    StatefulPreviewWrapper<Mood?, SwipeView>(initialValue: .some(.happy)) { moodBinding in
        SwipeView(viewModel: MovieViewModel(), selectedMood: moodBinding)
    }
}
