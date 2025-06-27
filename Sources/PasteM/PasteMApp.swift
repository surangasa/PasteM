import SwiftUI
import AppKit

@main
struct PasteMApp: App {
    // The AppDelegate will handle status bar and menu setup
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // Settings scene for preferences
        Settings {
            PreferencesView()
        }
    }
}
