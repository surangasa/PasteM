import Foundation
import AppKit

/// Monitors the system pasteboard and stores recent clipboard items.
final class ClipboardStore: ObservableObject {
    /// Maximum number of recent items to keep
    @Published var limit: Int = 20
    /// All clipboard items sorted by date (most recent first)
    @Published private(set) var items: [ClipboardItem] = []

    /// Timer for polling the pasteboard
    private var timer: Timer?
    private var changeCount: Int = NSPasteboard.general.changeCount

    /// Path where items are persisted
    private var archiveURL: URL {
        let supportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = supportDir.appendingPathComponent("PasteM", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("history.json")
    }

    /// Start monitoring the clipboard
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
        loadFromDisk()
    }

    deinit {
        timer?.invalidate()
    }

    /// Poll the clipboard for changes
    private func checkClipboard() {
        let pb = NSPasteboard.general
        guard pb.changeCount != changeCount else { return }
        changeCount = pb.changeCount

        if let newItem = readPasteboard(pb) {
            DispatchQueue.main.async {
                self.prepend(newItem)
            }
        }
    }

    /// Read pasteboard contents as ClipboardItem
    private func readPasteboard(_ pb: NSPasteboard) -> ClipboardItem? {
        if let str = pb.string(forType: .string) {
            return ClipboardItem(id: UUID(), date: Date(), isFavorite: false, content: .text(str))
        }
        if let data = pb.data(forType: .png) {
            return ClipboardItem(id: UUID(), date: Date(), isFavorite: false, content: .image(data))
        }
        if let urlStr = pb.string(forType: .fileURL), let url = URL(string: urlStr) {
            return ClipboardItem(id: UUID(), date: Date(), isFavorite: false, content: .url(url))
        }
        return nil
    }

    /// Insert item and trim history
    private func prepend(_ item: ClipboardItem) {
        items.insert(item, at: 0)
        if items.count > limit {
            items.removeLast(items.count - limit)
        }
        saveToDisk()
    }

    /// Toggle favorite flag for item
    func toggleFavorite(_ item: ClipboardItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isFavorite.toggle()
            saveToDisk()
        }
    }

    /// Persist items to disk
    private func saveToDisk() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: archiveURL)
        } catch {
            NSLog("Failed to save history: \(error)")
        }
    }

    /// Load saved history
    private func loadFromDisk() {
        do {
            let data = try Data(contentsOf: archiveURL)
            items = try JSONDecoder().decode([ClipboardItem].self, from: data)
        } catch {
            // ignore if no history yet
            items = []
        }
    }
}
