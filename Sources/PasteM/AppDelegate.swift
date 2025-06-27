import Cocoa
import SwiftUI

/// Main application delegate responsible for managing the status bar item
/// and injecting shared stores.
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    
    /// Shared clipboard store accessible across the app.
    let clipboardStore = ClipboardStore()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up status bar item with icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clipboard")
            button.action = #selector(togglePopover(_:))
        }

        // Configure SwiftUI view inside a popover
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 300, height: 400)
        popover.contentViewController = NSHostingController(rootView: ClipboardView().environmentObject(clipboardStore))

        // Start monitoring clipboard
        clipboardStore.startMonitoring()
    }

    /// Toggles the popover when the menu bar icon is clicked
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            popover.performClose(sender)
        } else if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
