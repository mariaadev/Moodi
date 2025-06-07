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
                  Color.black.ignoresSafeArea()

                  VStack(spacing: 20) {
                      Image("moodiLogo")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 250, height: 200)
                  }
              }
          
    }
}

#Preview {
    SplashView()
}
