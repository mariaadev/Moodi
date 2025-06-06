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
        VStack(spacing: 20) {
                    Text("How are you feeling?")
                        .font(.largeTitle)
                        .bold()
                    
                    ForEach(Mood.allCases) { mood in
                        Button(action: {
                            selectedMood = mood
                        }) {
                            Text(mood.rawValue.capitalized)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
    }
}

#Preview {
    StatefulPreviewWrapper(initialValue: Mood?.none) { binding in
        MoodSelectionView(selectedMood: binding)
    }
}
