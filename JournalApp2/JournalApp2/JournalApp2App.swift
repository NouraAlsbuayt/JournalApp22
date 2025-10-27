import SwiftUI

@main
struct JournaliApp2: App {
    @StateObject private var store = JournalStore()
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            RootView(store: store)

            .preferredColorScheme(.dark)
        }
    }
}

