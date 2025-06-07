//
//  SplashView.swift
//  Moodi
//
//  Created by Maria Amzil on 7/6/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.black
                      Image("moodiLogo")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 250, height: 200)
                          .padding()
                    
                      }
        .edgesIgnoringSafeArea(.all) 
    }
}

#Preview {
    SplashView()
}
