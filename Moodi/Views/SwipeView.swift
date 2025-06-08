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
    @State private var rotationAngle: Double = 0
    
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
                    ForEach(Array(viewModel.movies.suffix(3).enumerated()), id: \.element.id) { index, movie in
                        let cardIndex = viewModel.movies.suffix(3).count - 1 - index
                        let isTopCard = cardIndex == 0
                                      
                        MovieCardView(movie: movie)
                            .scaleEffect(isTopCard ? 1.0 : 1.0 - CGFloat(cardIndex) * 0.03)
                            .opacity(1.0)
                            .offset(
                                x: isTopCard ? dragOffset.width : 0,
                                y: isTopCard ? dragOffset.height : CGFloat(cardIndex) * 3
                                          )
                            .rotationEffect(.degrees(isTopCard ? rotationAngle : 0))
                            .zIndex(isTopCard ? 10 : Double(10 - cardIndex))
                            .animation(
                                isTopCard && !isAnimating ? .none : .spring(response: 0.4, dampingFraction: 0.8),
                                value: dragOffset
                            )
                            .gesture(
                                isTopCard ?
                                DragGesture()
                                    .onChanged { value in
                                        guard !isAnimating else { return }
                                        dragOffset = value.translation
                                        rotationAngle = Double(value.translation.width / 10)
                                    }
                                    .onEnded { value in
                                        guard !isAnimating else { return }
                                        let threshold: CGFloat = 100
                                        if value.translation.width > threshold {
                                            animateSwipe(.right, movie)
                                        } else if value.translation.width < -threshold {
                                            animateSwipe(.left, movie)
                                        } else {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                dragOffset = .zero
                                                rotationAngle = 0
                                            }
                                        }
                                    }
                                    : nil
                                    )
                                }
                        }
                        .frame(height: 600)
                        HStack(spacing: 50) {
                               Button(action: {
                                   guard let current = viewModel.movies.last, !isAnimating else { return }
                                                        animateSwipe(.left, current)
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
                               .disabled(isAnimating || viewModel.movies.isEmpty)

                               Button(action: {
                                   guard let current = viewModel.movies.last, !isAnimating else { return }
                                                       animateSwipe(.right, current)
                                      
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
                               .disabled(isAnimating || viewModel.movies.isEmpty)
                }
                .offset(y: -30)
                .padding(.top, 20)
            
            }
        }
    }
    
    func animateSwipe(_ direction: SwipeDirection, _ movie: Movie) {
        guard !isAnimating else { return }
        isAnimating = true
        
        let exitOffset = CGSize(
                   width: direction == .right ? UIScreen.main.bounds.width + 100 : -UIScreen.main.bounds.width - 100,
                   height: dragOffset.height + (direction == .right ? -50 : 50)
               )
        
        withAnimation(.easeInOut(duration: 0.4)) {
                  dragOffset = exitOffset
                  rotationAngle = direction == .right ? 15 : -15
              }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if direction == .right {
                viewModel.swipeRight(movie: movie)
            } else {
                viewModel.swipeLeft(movie: movie)
            }
            
            dragOffset = .zero
            rotationAngle = 0
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
