import SwiftUI
import AppKit
import PGPCore

/// PGP.mac - The coolest menu bar app for encryption!
/// Living in your menu bar, ready to encrypt at a moment's notice
///
/// Partners: Hue & Aye @ 8b.is

@main
struct PGPmacApp: App {
    /// Our app delegate handles the menu bar icon and popover
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // We don't want a traditional window - we're a menu bar app!
        // But we need this for Settings to work properly
        Settings {
            EmptyView()
        }
    }
}

/// AppDelegate manages our menu bar presence
/// This is where we set up the cool icon in your menu bar!
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    /// The menu bar item (our home in the menu bar)
    private var statusItem: NSStatusItem!

    /// The popover that shows our UI
    private var popover: NSPopover!

    /// The key manager - our crypto brain
    @Published var keyManager = KeyManager()

    /// The hotkey manager - making encryption accessible anywhere!
    private var hotkeyManager: HotkeyManager?

    /// Called when the app launches - let's set up shop!
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the menu bar item with a fixed length
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        // Set up our icon - a nice lock symbol
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "lock.shield.fill",
                accessibilityDescription: "PGP.mac"
            )
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Create the popover that will show our UI
        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 600)
        popover.behavior = .transient  // Closes when you click outside
        popover.contentViewController = NSHostingController(
            rootView: ContentView()
                .environmentObject(keyManager)
        )

        // Make sure we can quit properly
        NSApp.setActivationPolicy(.accessory)

        // Initialize hotkey manager for global shortcuts
        hotkeyManager = HotkeyManager(keyManager: keyManager)
    }

    /// Toggle the popover when the menu bar icon is clicked
    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                // Activate the app so the popover gets focus
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    /// Handle app termination gracefully
    func applicationWillTerminate(_ notification: Notification) {
        // Save any pending changes
        // KeyManager auto-saves, so we're good!
    }

    /// Support quitting via Cmd+Q
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false  // We're a menu bar app, no windows to close!
    }
}
