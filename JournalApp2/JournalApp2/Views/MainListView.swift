//
//  MainListView.swift
//  JournalApp2
//
//  Created by Noura Alsbuayt on 01/05/1447 AH.
//

import SwiftUI
import UIKit   

struct MainListView: View {
    @ObservedObject var store: JournalStore

    @State private var editingItem: Journal? = nil
    @State private var showDeleteConfirm: Journal? = nil

    @State private var showScrollToTop = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.journalBlack, Color.journalBlack], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Journal")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    ToolbarButtons(store: store) {
                        editingItem = .init(title: "", snippet: "", date: .now)
                    }
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.top, 8)
                .padding(.bottom, 8)

                ScrollViewReader { proxy in
                    ZStack {
                        List {
                            Color.clear
                                .frame(height: 0.1)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .id("TOP")

                            ForEach(store.filtered) { item in
                                JournalCardView(
                                    item: item,
                                    onBookmark: { store.toggleBookmark(item) },
                                    onEdit: { editingItem = item }
                                )
                                .contentShape(Rectangle())
                                .onTapGesture { editingItem = item }
                                .listRowInsets(EdgeInsets(
                                    top: 6,
                                    leading: Metrics.screenPadding,
                                    bottom: Metrics.listSpacing,
                                    trailing: Metrics.screenPadding
                                ))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)

                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                                        showDeleteConfirm = item
                                    } label: { Label("Delete", systemImage: "trash") }
                                }

                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        store.toggleBookmark(item)
                                    } label: {
                                        Label(item.isBookmarked ? "Unbookmark" : "Bookmark",
                                              systemImage: item.isBookmarked ? "bookmark.slash" : "bookmark")
                                    }
                                    .tint(.yellow)
                                }

                                .contextMenu {
                                    Button(item.isBookmarked ? "Remove Bookmark" : "Add Bookmark") {
                                        store.toggleBookmark(item)
                                    }
                                    Button("Edit") { editingItem = item }

                                    Button("Copy", systemImage: "doc.on.doc") {
                                        UIPasteboard.general.string = "\(item.title)\n\(item.snippet)"
                                    }

                                    Button("Delete", role: .destructive) {
                                        showDeleteConfirm = item
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)

                        if store.filtered.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 34, weight: .semibold))
                                    .foregroundStyle(Color.journalWhite)
                                Text("No journals found")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color.journalWhite)
                            }
                            .padding(.top, 60)
                        }
                    }
                   
                    
                    .onChange(of: store.search) { _ in
                        withAnimation(.easeOut) {
                            proxy.scrollTo("TOP", anchor: .top)
                        }
                    }
                   
                    .onChange(of: store.filtered.count) { _ in
                        showScrollToTop = store.filtered.count > 8
                    }
                    .overlay(alignment: .bottomTrailing) {
                        if showScrollToTop {
                            Button {
                                withAnimation(.spring()) {
                                    proxy.scrollTo("TOP", anchor: .top)
                                }
                            } label: {
                                Image(systemName: "arrow.up.to.line")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.black.opacity(0.9))
                                    .frame(width: 42, height: 42)
                                    .background(Color.accent, in: Circle())
                                    .shadow(radius: 12)
                                    .padding(.trailing, Metrics.screenPadding)
                                    .padding(.bottom, 90)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale)
                        }
                    }
                }
            }
        }

        .safeAreaInset(edge: .bottom) {
            GlassySearchBar(searchText: $store.search)
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.bottom, 8)
        }

        .sheet(item: $editingItem) { item in
            EditorView(
                initial: item,
                onSave: { updated in
                    store.upsert(updated)
                    editingItem = nil
                },
                onCancel: { editingItem = nil }
            )
            .presentationDetents([.medium, .large])
        }

        .alert(
            "Delete journal?",
            isPresented: .constant(showDeleteConfirm != nil),
            presenting: showDeleteConfirm
        ) { item in
            Button("Delete", role: .destructive) {
                store.delete(item)
                showDeleteConfirm = nil
            }
            Button("Cancel", role: .cancel) {
                showDeleteConfirm = nil
            }
        } message: { _ in
            Text("Are you sure you want to delete this journal?")
        }
    }
}

struct JournalCardView: View {
    let item: Journal
    let onBookmark: () -> Void
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title.isEmpty ? "Untitled" : item.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.accent)

                    Text(
                        item.date.formatted(
                            .dateTime
                                .day(.twoDigits)
                                .month(.twoDigits)
                                .year(.defaultDigits)
                                .locale(Locale(identifier: "en_GB"))
                        )
                    )
                    .font(.system(size: 12))
                    .foregroundStyle(Color.journalWhite)
                }

                Spacer(minLength: 8)

                Button(action: onBookmark) {
                    Image(systemName: item.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.accent)
                        .padding(.top, 2)
                }
                .buttonStyle(.plain)
            }

            Text(item.snippet)
                .font(.system(size: 14))
                .foregroundStyle(Color.journalWhite)
                .lineLimit(3)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.journalBlack)
        )
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 6)
        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .onTapGesture { onEdit() }
        .accessibilityAddTraits(.isButton)
    }
}



#Preview {
    NavigationStack {
        MainListView(store: JournalStore())
    }
    .preferredColorScheme(.dark)
}
