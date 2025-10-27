//
//  RootView.swift
//  JournalApp2
//

import SwiftUI

struct RootView: View {
    @ObservedObject var store: JournalStore
    @State private var showingAdd = false
    @State private var showingSplash = true   

    var body: some View {
        ZStack {
            if showingSplash {
                SplashView {
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.easeOut) {
                            showingSplash = false
                        }
                    }
                }
            } else {
                
                Group {
                    if store.items.isEmpty {
                        EmptyStateView(store: store) {
                            showingAdd = true
                        }
                    } else {
                        NavigationStack {
                            MainListView(store: store)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            EditorView(
                initial: .init(title: "", snippet: "", date: .now),
                onSave: { item in
                    store.upsert(item)
                    showingAdd = false
                },
                onCancel: {
                    showingAdd = false
                }
            )
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    RootView(store: JournalStore())
}
