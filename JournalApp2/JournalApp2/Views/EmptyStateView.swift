//
//  EmptyStateView.swift
//  JournalApp2
//

import SwiftUI

struct EmptyStateView: View {
    @ObservedObject var store: JournalStore
    var onAdd: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.journalBlack, Color.journalBlack], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Journal")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.journalWhite)
                    Spacer()
                    ToolbarButtons(store: store, onAdd: onAdd)
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.top, 8)
                
                Spacer()
                
                // Empty content
                VStack(spacing: 10) {
                    
                   
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .shadow(radius: 12)
                        
                    
                    
                    Text("Begin Your Journal")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.purpleText)
                    
                    Text("Craft your personal diary, tap the plus icon to begin")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.journalWhite)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                Spacer(minLength: 100)
            }
            
                    .safeAreaInset(edge: .bottom) {
                        GlassySearchBar(searchText: $store.search)
                            .padding(.horizontal, Metrics.screenPadding)
                            .padding(.bottom, 8)
                    }
        }
   }
}

#Preview {
    EmptyStateView(store: JournalStore()) {
        // onAdd
    }
}
