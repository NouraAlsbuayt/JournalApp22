//
//  JournalStore.swift
//  JournalApp2
//

import SwiftUI
import Combine

@MainActor
final class JournalStore: ObservableObject {
    @Published var items: [Journal] = []
    @Published var search: String = ""
    @Published var showOnlyBookmarks: Bool = false
    @Published var sortByDate: Bool = true
    @Published var sortBookmarks: Bool = true

    var filtered: [Journal] {
        var list = items

        if showOnlyBookmarks {
            list = list.filter { $0.isBookmarked }
        }

        let q = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            list = list.filter {
                $0.title.lowercased().contains(q) ||
                $0.snippet.lowercased().contains(q)
            }
        }

        list.sort { a, b in
            if sortBookmarks && a.isBookmarked != b.isBookmarked {
                return a.isBookmarked && !b.isBookmarked
            }
            return sortByDate ? a.date > b.date : a.date < b.date
        }

        return list
    }

    func toggleBookmarkFilter() { showOnlyBookmarks.toggle() }
    func toggleSortOrder() { sortByDate.toggle() }
    func toggleBookmarkPriority() { sortBookmarks.toggle() }

    func toggleBookmark(_ item: Journal) {
        guard let i = items.firstIndex(of: item) else { return }
        items[i].isBookmarked.toggle()
    }

    func delete(_ item: Journal) {
        items.removeAll { $0.id == item.id }
    }

    func upsert(_ item: Journal) {
        if let i = items.firstIndex(where: { $0.id == item.id }) {
            items[i] = item
        } else {
            items.insert(item, at: 0)
        }
    }
}
