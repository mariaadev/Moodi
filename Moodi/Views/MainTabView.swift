//
//  MainTabView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI
import UIKit

struct MainTabView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var selectedMood: Mood?
    
    init(viewModel: MovieViewModel, selectedMood: Binding<Mood?>) {
           self.viewModel = viewModel
           self._selectedMood = selectedMood
           
           let appearance = UITabBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = UIColor(Color.backgroundColor)

           UITabBar.appearance().standardAppearance = appearance
           if #available(iOS 15.0, *) {
               UITabBar.appearance().scrollEdgeAppearance = appearance
           }
       }
       

    
    var body: some View {
            TabView {
                SwipeView(viewModel: viewModel, selectedMood: $selectedMood)
                    .tabItem {
                        Image("homeWhite")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
    
                        Text("Home")
                            .font(.custom("Poppins-Medium", size:10))
                    }
                  
                
                SavedMoviesView(viewModel: viewModel)
                   
                    .tabItem {
                        Image("bookmarkWhite")
                            .renderingMode(.template)
                        Text("My List")
                            .font(.custom("Poppins-Medium", size:10))
                           
                    }
            }
            .background(Color.backgroundColor)
        
    }
}

#Preview {
    StatefulPreviewWrapper<Mood?, MainTabView>(initialValue: Mood?.some(.happy)) { moodBinding in
        MainTabView(viewModel: MovieViewModel(), selectedMood: moodBinding)
    }
}
