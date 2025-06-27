import SwiftUI

/// Preferences window for setting history limit and launch on login
struct PreferencesView: View {
    @EnvironmentObject var store: ClipboardStore
    @AppStorage("launchAtLogin") private var launchAtLogin: Bool = false

    var body: some View {
        Form {
            Stepper(value: $store.limit, in: 5...100, step: 1) {
                Text("History Limit: \(store.limit)")
            }
            Toggle("Launch at Login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { value in
                    StartupManager.setLaunchAtLogin(enabled: value)
                }
        }
        .padding()
        .frame(width: 300)
    }
}
