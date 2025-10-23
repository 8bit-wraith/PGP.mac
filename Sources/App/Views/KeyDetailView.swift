import PGPCore
import SwiftUI

/// Detailed view of a specific key
/// All the nerdy details you could want!
///
/// Partners: Hue & Aye @ 8b.is
struct KeyDetailView: View {
    @EnvironmentObject var keyManager: KeyManager
    let keyPair: PGPKeyPair

    @State private var showingExport = false
    @State private var exportedKey = ""

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(keyPair.statusEmoji)
                    .font(.largeTitle)

                VStack(alignment: .leading) {
                    Text(keyPair.nickname)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(keyPair.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            Divider()

            // Details
            VStack(alignment: .leading, spacing: 12) {
                detailRow(
                    label: "Type",
                    value: keyPair.keyTypeDescription,
                    icon: keyPair.hasPrivateKey ? "key.fill" : "key",
                )

                detailRow(
                    label: "Fingerprint",
                    value: keyPair.fingerprint,
                    icon: "hand.raised.fill",
                    monospaced: true,
                )

                detailRow(
                    label: "Short Fingerprint",
                    value: keyPair.shortFingerprint,
                    icon: "hand.raised",
                    monospaced: true,
                )

                detailRow(
                    label: "Created",
                    value: formatDate(keyPair.createdDate),
                    icon: "calendar",
                )

                if let expiration = keyPair.expirationDate {
                    detailRow(
                        label: "Expires",
                        value: formatDate(expiration),
                        icon: "clock",
                        warning: keyPair.isExpired,
                    )
                } else {
                    detailRow(
                        label: "Expires",
                        value: "Never",
                        icon: "infinity",
                    )
                }

                detailRow(
                    label: "Status",
                    value: keyPair.isValid ? "Valid" : "Expired",
                    icon: keyPair.isValid ? "checkmark.circle.fill" : "xmark.circle.fill",
                    warning: !keyPair.isValid,
                )
            }

            // User IDs
            if !keyPair.userIDs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                        Text("User IDs")
                            .font(.headline)
                    }

                    ForEach(keyPair.userIDs, id: \.self) { userID in
                        Text(userID)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(4)
                    }
                }
            }

            Spacer()

            // Actions
            HStack {
                Button(action: exportPublicKey) {
                    Label("Export Public Key", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)

                Spacer()
            }

            // Exported key display
            if showingExport {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Exported Key")
                            .font(.headline)

                        Spacer()

                        Button(action: copyExportedKey) {
                            Label("Copy", systemImage: "doc.on.doc")
                                .font(.caption)
                        }
                        .buttonStyle(.borderless)
                    }

                    ScrollView {
                        Text(exportedKey)
                            .font(.system(.caption2, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 150)
                    .padding(8)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(6)
                }
            }
        }
        .padding()
        .frame(width: 500)
    }

    // MARK: - Helper Views

    private func detailRow(
        label: String,
        value: String,
        icon: String,
        monospaced: Bool = false,
        warning: Bool = false,
    ) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(warning ? .red : .blue)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(monospaced ? .system(.body, design: .monospaced) : .body)
                    .foregroundColor(warning ? .red : .primary)
                    .textSelection(.enabled)
            }

            Spacer()
        }
        .padding(8)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(6)
    }

    // MARK: - Actions

    private func exportPublicKey() {
        do {
            exportedKey = try keyPair.exportArmored(includePrivate: false)
            showingExport = true
        } catch {
            // Error alert - future enhancement
            print("Export failed: \(error)")
        }
    }

    private func copyExportedKey() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(exportedKey, forType: .string)

        // Success notification - future enhancement
    }

    // MARK: - Helpers

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    let manager = KeyManager()
    // Preview data - future enhancement
    return KeyDetailView(keyPair: PGPKeyPair(
        id: UUID(),
        keyData: Data(),
        nickname: "Test Key",
        email: "test@example.com",
        createdDate: Date(),
        expirationDate: nil,
        hasPrivateKey: true,
        fingerprint: "1234 5678 90AB CDEF",
        userIDs: ["Test User <test@example.com>"],
    ))
    .environmentObject(manager)
}
