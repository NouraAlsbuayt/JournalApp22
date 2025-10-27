//
//  SplashView.swift
//  JournalApp2
//
//  Created by Noura Alsbuayt on 01/05/1447 AH.
//

import SwiftUI

struct SplashView: View {
    @State private var fadeIn = false
    var onDone: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.journalBlack, Color.journalBlack], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image( "Splach") 
                    .font(.system(size: 120))
                    .foregroundStyle(.white.opacity(0.95))
                    .shadow(radius: 20)
                    .scaleEffect(fadeIn ? 1 : 0.8)
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.spring(response: 0.9, dampingFraction: 0.75), value: fadeIn)
                
                Text("Journali")
                    .font(.system(size: 56, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: fadeIn)
                
                Text("Your thoughts, your story")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color.journalWhite)
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: fadeIn)
            }
        }
        .onAppear {
            fadeIn = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                onDone()
            }
        }
    }
}

