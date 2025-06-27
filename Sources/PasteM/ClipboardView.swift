import SwiftUI

/// Main view displayed inside the status bar popover
struct ClipboardView: View {
    @EnvironmentObject var store: ClipboardStore
    @State private var searchText = ""

    var filteredItems: [ClipboardItem] {
        if searchText.isEmpty { return store.items }
        return store.items.filter { item in
            switch item.content {
            case .text(let str):
                return str.lowercased().contains(searchText.lowercased())
            case .url(let url):
                return url.absoluteString.lowercased().contains(searchText.lowercased())
            case .image:
                return false
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            SearchField(text: $searchText)
                .padding([.top, .leading, .trailing])

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(filteredItems) { item in
                        ClipboardRow(item: item)
                            .contextMenu {
                                Button(item.isFavorite ? "Unfavorite" : "Favorite") {
                                    store.toggleFavorite(item)
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(minWidth: 280, minHeight: 300)
    }
}

/// Search field wrapper to support older macOS versions
struct SearchField: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSSearchField {
        let field = NSSearchField(string: text)
        field.delegate = context.coordinator
        return field
    }

    func updateNSView(_ nsView: NSSearchField, context: Context) {
        nsView.stringValue = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSSearchFieldDelegate {
        var parent: SearchField
        init(_ parent: SearchField) { self.parent = parent }
        func controlTextDidChange(_ obj: Notification) {
            if let field = obj.object as? NSSearchField {
                parent.text = field.stringValue
            }
        }
    }
}
