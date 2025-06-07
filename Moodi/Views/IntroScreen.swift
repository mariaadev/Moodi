//
//  IntroScreen.swift
//  Moodi
//
//  Created by Maria Amzil on 7/6/25.
//

import SwiftUI

struct IntroScreen: View {
    @AppStorage("hasSeenIntro") var hasSeenIntro: Bool = false
    var body: some View {
        VStack(spacing: 40) {
                   Spacer()
            Image("moodiLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 200)
            
            Text("Swipe your way to the perfect movie.")
                .font(.custom("Poppins-Medium", size:16))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.textColor)
                .offset(y: -70)

            
            Button(action: {
                hasSeenIntro = true
            }) {
                Text("Swipe Movies")
                    .font(.custom("Poppins-Medium", size:16))
                    .padding(10)
                    .frame(maxWidth: 150)
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
            }.offset(y: -50)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
    }
}

#Preview {
    IntroScreen()
}
