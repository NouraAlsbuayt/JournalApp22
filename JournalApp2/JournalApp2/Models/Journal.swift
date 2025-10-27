//
//  Journal.swift
//  JournalApp2
//
//  Created by Noura Alsbuayt on 01/05/1447 AH.
//

import Foundation

struct Journal: Identifiable, Equatable {
    let id: UUID
    var title: String
    var snippet: String
    var date: Date
    var isBookmarked: Bool
    
    init(id: UUID = UUID(),
         title: String,
         snippet: String,
         date: Date = .init(),
         isBookmarked: Bool = false) {
        self.id = id
        self.title = title
        self.snippet = snippet
        self.date = date
        self.isBookmarked = isBookmarked
    }
}
