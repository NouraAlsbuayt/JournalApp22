import SwiftUI

struct ToolbarButtons: View {
    @ObservedObject var store: JournalStore
    var onAdd: () -> Void

    var body: some View {
        GlassPill {
            Menu {
                Section {
                    Toggle("Show only Bookmarks", isOn: $store.showOnlyBookmarks)
                }
                Section {
                    Toggle("Sort by Entry Date", isOn: $store.sortByDate)
                }
            } label: {
                PillIcon(systemName: "line.3.horizontal.decrease")
                    .contentShape(Rectangle())
            }

            Button(action: onAdd) {
                PillIcon(systemName: "plus")
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .fixedSize()
    }
}

private struct GlassPill<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        HStack(spacing: 14) {
            content
        }
        .padding(.horizontal, 14)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("buttonColor")) // dark base
                .glassEffect(
                    .regular
                        .tint(Color("buttonColor")) // match your dark theme
                        .interactive(),             // subtle motion & reflection
                    in: RoundedRectangle(cornerRadius: 18)
                )
        )
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 6)     }
}

private struct PillIcon: View {
    let systemName: String
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(.white.opacity(0.92))
            .padding(.vertical, 8)
    }
}




