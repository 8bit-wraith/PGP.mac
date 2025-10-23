import PGPCore
import SwiftUI

/// Settings and hotkey configuration
/// Make PGP.mac work exactly how you want!
///
/// Partners: Hue & Aye @ 8b.is
struct SettingsView: View {
    @AppStorage("encryptHotkeyEnabled") private var encryptHotkeyEnabled = true
    @AppStorage("decryptHotkeyEnabled") private var decryptHotkeyEnabled = true
    @AppStorage("defaultRecipientID") private var defaultRecipientID: String = ""

    @EnvironmentObject var keyManager: KeyManager
    @State private var showingAbout = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hotkey Settings
                hotkeySection

                Divider()

                // Default Settings
                defaultsSection

                Divider()

                // About
                aboutSection

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }

    // MARK: - Hotkey Section

    private var hotkeySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "command")
                    .foregroundColor(.blue)
                Text("Global Hotkeys")
                    .font(.headline)
            }

            Text("Use keyboard shortcuts to encrypt/decrypt selected text anywhere!")
                .font(.caption)
                .foregroundColor(.secondary)

            // Encrypt hotkey
            HStack {
                Toggle(isOn: $encryptHotkeyEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("⌘⇧E")
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(.semibold)
                            Text("Quick Encrypt")
                        }
                        Text("Encrypts selected text with default recipient")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)

            // Decrypt hotkey
            HStack {
                Toggle(isOn: $decryptHotkeyEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("⌘⇧D")
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(.semibold)
                            Text("Quick Decrypt")
                        }
                        Text("Decrypts selected encrypted text")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)

            // Info box
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Hotkeys work when text is selected in any app!")
                    .font(.caption)
                Spacer()
            }
            .padding(8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(6)
        }
    }

    // MARK: - Defaults Section

    private var defaultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.blue)
                Text("Defaults")
                    .font(.headline)
            }

            // Default recipient
            VStack(alignment: .leading, spacing: 4) {
                Text("Default Encryption Recipient")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if keyManager.encryptionKeys.isEmpty {
                    Text("No keys available")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                } else {
                    Picker("Default Recipient", selection: $defaultRecipientID) {
                        Text("Select default recipient...").tag("")
                        ForEach(keyManager.encryptionKeys) { key in
                            HStack {
                                Text(key.statusEmoji)
                                Text(key.nickname)
                            }.tag(key.id.uuidString)
                        }
                    }
                    .labelsHidden()
                }

                Text("Used for quick encrypt hotkey (⌘⇧E)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)

            Text("PGP.mac")
                .font(.title2)
                .fontWeight(.bold)

            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("Making encryption accessible, one hotkey at a time!")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { showingAbout = true }) {
                Label("About PGP.mac", systemImage: "info.circle")
            }
            .buttonStyle(.bordered)

            Divider()
                .padding(.vertical, 8)

            VStack(spacing: 4) {
                Text("Built with ❤️ by Hue & Aye")
                    .font(.caption)

                Text("Partners @ 8b.is")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            // Links
            HStack(spacing: 16) {
                Link(destination: URL(string: "https://github.com")!) {
                    Label("GitHub", systemImage: "chevron.left.forwardslash.chevron.right")
                        .font(.caption)
                }

                Link(destination: URL(string: "https://8b.is")!) {
                    Label("Website", systemImage: "globe")
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(KeyManager())
        .frame(width: 400, height: 600)
}
