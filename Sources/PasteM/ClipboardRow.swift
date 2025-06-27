import SwiftUI

/// Displays a single clipboard entry
struct ClipboardRow: View {
    let item: ClipboardItem

    var body: some View {
        HStack(alignment: .top) {
            thumbnail
            VStack(alignment: .leading) {
                contentText
                Text(item.date, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                NSPasteboard.general.clearContents()
                switch item.content {
                case .text(let str):
                    NSPasteboard.general.setString(str, forType: .string)
                case .image(let data):
                    if let img = NSImage(data: data) {
                        NSPasteboard.general.writeObjects([img])
                    }
                case .url(let url):
                    NSPasteboard.general.setString(url.absoluteString, forType: .string)
                }
            }) {
                Image(systemName: "doc.on.doc")
            }
        }
        .padding(4)
        .background(item.isFavorite ? Color.yellow.opacity(0.2) : Color.clear)
        .cornerRadius(4)
    }

    /// Generates a preview thumbnail based on content type
    private var thumbnail: some View {
        Group {
            switch item.content {
            case .text:
                Image(systemName: item.isFavorite ? "star.fill" : "doc.text")
                    .foregroundColor(item.isFavorite ? .yellow : .accentColor)
            case .image(let data):
                if let img = NSImage(data: data) {
                    Image(nsImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "photo")
                }
            case .url:
                Image(systemName: "link")
            }
        }
        .frame(width: 30, height: 30)
    }

    /// Text representation of the content
    private var contentText: some View {
        Group {
            switch item.content {
            case .text(let str):
                Text(str).lineLimit(2)
            case .image:
                Text("Image")
            case .url(let url):
                Text(url.absoluteString)
            }
        }
    }
}
