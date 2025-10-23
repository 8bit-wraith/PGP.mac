import PGPCore
import SwiftUI

/// Shows all your PGP keys in a beautiful list
/// Like a contact list, but for crypto identities!
///
/// Partners: Hue & Aye @ 8b.is
struct KeyListView: View {
    @EnvironmentObject var keyManager: KeyManager

    /// Are we showing the import sheet?
    @State private var showingImport = false

    /// Are we showing the generate key sheet?
    @State private var showingGenerate = false

    /// Selected key for detail view
    @State private var selectedKey: PGPKeyPair?

    var body: some View {
        VStack(spacing: 0) {
            // Action buttons
            actionButtons

            Divider()

            // Key list
            if keyManager.keyPairs.isEmpty {
                emptyStateView
            } else {
                keyList
            }
        }
        .sheet(isPresented: $showingImport) {
            ImportKeyView(isPresented: $showingImport)
        }
        .sheet(isPresented: $showingGenerate) {
            GenerateKeyView(isPresented: $showingGenerate)
        }
        .sheet(item: $selectedKey) { key in
            KeyDetailView(keyPair: key)
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack {
            Button(action: { showingImport = true }) {
                Label("Import", systemImage: "square.and.arrow.down")
            }

            Button(action: { showingGenerate = true }) {
                Label("Generate", systemImage: "plus.circle")
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "key.slash")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No Keys Yet!")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Import a key or generate a new one to get started")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button(action: { showingImport = true }) {
                    Label("Import Key", systemImage: "square.and.arrow.down")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button(action: { showingGenerate = true }) {
                    Label("Generate New Key", systemImage: "plus.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: - Key List

    private var keyList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(keyManager.keyPairs) { keyPair in
                    KeyRowView(keyPair: keyPair)
                        .onTapGesture {
                            selectedKey = keyPair
                        }
                        .contextMenu {
                            keyContextMenu(for: keyPair)
                        }
                }
            }
            .padding()
        }
    }

    // MARK: - Context Menu

    @ViewBuilder
    private func keyContextMenu(for keyPair: PGPKeyPair) -> some View {
        Button(action: {
            selectedKey = keyPair
        }) {
            Label("View Details", systemImage: "info.circle")
        }

        Button(action: {
            exportKey(keyPair)
        }) {
            Label("Export Public Key", systemImage: "square.and.arrow.up")
        }

        if keyPair.hasPrivateKey {
            Button(action: {
                // Export private key with confirmation - future enhancement
            }) {
                Label("Export Private Key", systemImage: "exclamationmark.triangle")
            }
        }

        Divider()

        Button(role: .destructive, action: {
            deleteKey(keyPair)
        }) {
            Label("Delete", systemImage: "trash")
        }
    }

    // MARK: - Actions

    private func exportKey(_ keyPair: PGPKeyPair) {
        do {
            let armored = try keyPair.exportArmored(includePrivate: false)

            // Copy to clipboard
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(armored, forType: .string)

            // Success notification - future enhancement
        } catch {
            // Error alert - future enhancement
            print("Export failed: \(error)")
        }
    }

    private func deleteKey(_ keyPair: PGPKeyPair) {
        do {
            try keyManager.deleteKey(keyPair)
        } catch {
            // Error alert - future enhancement
            print("Delete failed: \(error)")
        }
    }
}

/// Individual key row in the list
/// Shows key info at a glance
struct KeyRowView: View {
    let keyPair: PGPKeyPair

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Status icon
            Text(keyPair.statusEmoji)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                // Nickname/email
                Text(keyPair.nickname)
                    .font(.headline)

                // Email (if different from nickname)
                if keyPair.email != keyPair.nickname {
                    Text(keyPair.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Fingerprint
                Text(keyPair.shortFingerprint)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontDesign(.monospaced)

                // Key type & status
                HStack(spacing: 8) {
                    Text(keyPair.keyTypeDescription)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            keyPair.hasPrivateKey ?
                                Color.blue.opacity(0.2) :
                                Color.gray.opacity(0.2),
                        )
                        .cornerRadius(4)

                    if keyPair.isExpired {
                        Text("EXPIRED")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }

            Spacer()

            // Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Preview

#Preview {
    KeyListView()
        .environmentObject(KeyManager())
        .frame(width: 400, height: 600)
}
