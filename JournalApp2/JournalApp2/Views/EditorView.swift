import SwiftUI

struct EditorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var draft: Journal
    @State private var original: Journal
    @State private var showDiscardSheet = false       

    var onSave: (Journal) -> Void
    var onCancel: () -> Void

    @FocusState private var focused: Field?
    private enum Field { case title, body }

    init(initial: Journal, onSave: @escaping (Journal) -> Void, onCancel: @escaping () -> Void) {
        _draft = State(initialValue: initial)
        _original = State(initialValue: initial)
        self.onSave = onSave
        self.onCancel = onCancel
    }

    private var hasChanges: Bool { draft != original }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 0.07, green: 0.07, blue: 0.08),
                                        Color(red: 0.04, green: 0.04, blue: 0.05)],
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Title", text: $draft.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.accent)
                            .tint(Color.accent)
                            .textInputAutocapitalization(.sentences)
                            .disableAutocorrection(false)
                            .focused($focused, equals: .title)

                        Text(
                            draft.date.formatted(
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

                    Rectangle().fill(Color.white.opacity(0.08)).frame(height: 1)

                    ZzzPlaceholderEditor(text: $draft.snippet,
                                         placeholder: "Type your Journal…")
                        .focused($focused, equals: .body)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if hasChanges {
                            showDiscardSheet = true
                        } else {
                            onCancel()
                            dismiss()
                        }
                    } label: {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white)
                            )
                            .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                            .frame(width: 34, height: 34)
                    }
                    .buttonStyle(.plain)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onSave(draft)
                        dismiss()
                    } label: {
                        Circle()
                            .fill(Color.accent)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black.opacity(0.9))
                            )
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)

            .modifier(InteractiveDismissGuard(
                isDirty: hasChanges,
                onAttempt: { showDiscardSheet = true }
            ))

            .alert("Are you sure you want to discard\nchanges on this journal?",
                   isPresented: $showDiscardSheet) {
                Button("Discard Changes", role: .destructive) {
                    onCancel()
                    dismiss()
                }
                Button("Keep Editing", role: .cancel) { /* no-op */ }
            }

            .onAppear {
                DispatchQueue.main.async {
                    focused = draft.title.isEmpty ? .title : .body
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}



fileprivate struct ZzzPlaceholderEditor: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.journalWhite)
                    .padding(.top, 8)
                    .padding(.leading, 4)
                    .allowsHitTesting(false)
            }
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .font(.system(size: 16))
                .foregroundStyle(Color.journalWhite)
                .tint(Color.accent)
                .frame(minHeight: 220)
        }
    }
}

fileprivate struct InteractiveDismissGuard: ViewModifier {
    let isDirty: Bool
    let onAttempt: () -> Void

    func body(content: Content) -> some View {
        content.interactiveDismissDisabled(isDirty)
    }
}

