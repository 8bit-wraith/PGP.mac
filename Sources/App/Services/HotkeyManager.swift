import AppKit
import Foundation
import PGPCore

/// HotkeyManager - Global hotkey support (simplified version)
/// Full implementation with Carbon Events coming soon!
/// Partners: Hue & Aye @ 8b.is
class HotkeyManager: ObservableObject {
    private let keyManager: KeyManager

    @Published var defaultRecipientID: String? {
        didSet {
            UserDefaults.standard.set(defaultRecipientID, forKey: "defaultRecipientID")
        }
    }

    init(keyManager: KeyManager) {
        self.keyManager = keyManager
        defaultRecipientID = UserDefaults.standard.string(forKey: "defaultRecipientID")

        // Register global hotkeys - full implementation coming soon
        // This requires Carbon Event Manager which is a bit tricky to integrate
        // For now, hotkeys can be added in a future update
        print("🎹 HotkeyManager initialized (hotkeys coming soon!)")
    }
}
