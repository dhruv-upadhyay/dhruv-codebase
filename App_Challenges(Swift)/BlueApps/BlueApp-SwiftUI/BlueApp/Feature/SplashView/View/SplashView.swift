//
//  SplashView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 20/04/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isRedirect = false
    var body: some View {
        if isRedirect {
            HomeView()
        } else {
            Image(.icSplash)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isRedirect = true
                        }
                    }
                }
        }
    }
}

#Preview {
    SplashView()
}
