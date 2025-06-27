import ServiceManagement

/// Manages enabling or disabling launch at login for the app
enum StartupManager {
    static func setLaunchAtLogin(enabled: Bool) {
        SMLoginItemSetEnabled(Bundle.main.bundleIdentifier! as CFString, enabled)
    }
}
