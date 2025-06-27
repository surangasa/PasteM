# PasteM

A minimal macOS menubar clipboard manager written in Swift/SwiftUI. This repository contains all source files needed to build the app. The `.xcodeproj` bundle is not included; follow the steps below to create one.

## Project Setup

1. Open **Xcode** and choose **File > New > Project**.
2. Select **App** and click **Next**.
3. Enter `PasteM` as the product name and ensure **Swift** and **SwiftUI** are selected.
4. Save the project inside this repository so that the `Sources` directory replaces the generated `ContentView.swift` and others.
5. Add the files from the `Sources/PasteM` directory to your Xcode target.

### Permissions
The app needs the following capabilities:
- **App Sandbox** enabled.
- **User Selected File** read/write for storing history.

For launch at login, the project must include the **ServiceManagement** framework.

### Code Signing
Use your Apple Developer account to sign the app for running outside of Xcode. For personal use, a free developer account works.

### Deployment
1. Build the project with **Product > Archive**.
2. Use the **Organizer** window to export the app or notarize it if distributing.

## Usage
Run the app from Xcode. A clipboard icon appears in the menubar. Click it to open the clipboard history. Items can be searched, copied again, or marked as favorites. Preferences allow changing the history limit and enabling launch at login.

## Extending
The code is heavily commented to explain the logic of each component. You can modify `ClipboardStore` to support additional data types or to integrate iCloud sync.
