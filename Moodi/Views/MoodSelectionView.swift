//
//  MoodSelectionView.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import SwiftUI

struct MoodSelectionView: View {
    @Binding var selectedMood: Mood?
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                   .ignoresSafeArea()
            VStack(spacing: 20) {
                        Text("How are you feeling?")
                            .font(.custom("Poppins-Medium", size:24))
                            .foregroundColor(Color.textColor)
                            .padding(.bottom, 20)
                
                        ForEach(Mood.allCases) { mood in
                            Button(action: {
                                selectedMood = mood
                            }) {
                                Text(mood.rawValue.capitalized)
                                    .font(.custom("Poppins-Medium", size:16))
                                    .frame(width: 247, height: 40)
                                    .padding(.bottom, 2)
                                    .padding(.top, 2)
                                    .background(Color.primaryColor)
                                    .cornerRadius(10)
                                    .foregroundColor(Color.textColor)
                            } .padding(5)
                        }
                    }
            .padding()
        }
    }
}

#Preview {
    StatefulPreviewWrapper(initialValue: Mood?.none) { binding in
        MoodSelectionView(selectedMood: binding)
    }
}
