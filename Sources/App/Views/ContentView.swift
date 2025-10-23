import SwiftUI
import PGPCore

/// The main view of PGP.mac
/// Your command center for all things encryption!
///
/// Partners: Hue & Aye @ 8b.is
struct ContentView: View {
    /// Access to our key manager
    @EnvironmentObject var keyManager: KeyManager

    /// Which tab are we showing?
    @State private var selectedTab: Tab = .keys

    /// Tabs available in the app
    enum Tab {
        case keys       // Manage your key collection
        case encrypt    // Encrypt messages
        case decrypt    // Decrypt messages
        case settings   // App settings & hotkeys
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with app branding
            headerView

            // Tab selector
            tabSelector

            Divider()

            // Content area
            Group {
                switch selectedTab {
                case .keys:
                    KeyListView()
                case .encrypt:
                    EncryptView()
                case .decrypt:
                    DecryptView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 400, height: 600)
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Image(systemName: "lock.shield.fill")
                .foregroundColor(.blue)
                .font(.title2)

            Text("PGP.mac")
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            // Quick stats
            Text("\(keyManager.keyPairs.count) keys")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Tab Selector

    private var tabSelector: some View {
        HStack(spacing: 0) {
            tabButton(tab: .keys, icon: "key.fill", label: "Keys")
            tabButton(tab: .encrypt, icon: "lock.fill", label: "Encrypt")
            tabButton(tab: .decrypt, icon: "lock.open.fill", label: "Decrypt")
            tabButton(tab: .settings, icon: "gear", label: "Settings")
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func tabButton(tab: Tab, icon: String, label: String) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                selectedTab == tab ?
                    Color.blue.opacity(0.2) :
                    Color.clear
            )
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(KeyManager())
}
