import Foundation
import AppKit

/// Represents a single clipboard entry. Supports text, images and URLs.
struct ClipboardItem: Identifiable, Codable {
    enum Content: Codable {
        case text(String)
        case image(Data) // PNG data
        case url(URL)
    }
    let id: UUID
    let date: Date
    var isFavorite: Bool
    var content: Content
}
