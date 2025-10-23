import SwiftUI
import PGPCore

/// Import a PGP key
/// Paste it, drop it, or pick a file - we handle it all!
///
/// Partners: Hue & Aye @ 8b.is
struct ImportKeyView: View {
    @EnvironmentObject var keyManager: KeyManager
    @Binding var isPresented: Bool

    @State private var keyText = ""
    @State private var nickname = ""
    @State private var errorMessage: String?
    @State private var isImporting = false

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Import PGP Key")
                .font(.title2)
                .fontWeight(.bold)

            // Instructions
            Text("Paste a PGP key or select a file")
                .font(.caption)
                .foregroundColor(.secondary)

            // Text area
            VStack(alignment: .leading, spacing: 4) {
                Text("PGP Key")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextEditor(text: $keyText)
                    .font(.system(.caption, design: .monospaced))
                    .frame(height: 200)
                    .border(Color.secondary.opacity(0.2))
            }

            // Nickname field
            VStack(alignment: .leading, spacing: 4) {
                Text("Nickname (optional)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextField("e.g., Work Email, Mom's Key", text: $nickname)
                    .textFieldStyle(.roundedBorder)
            }

            // Error message
            if let error = errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding(8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
            }

            // Buttons
            HStack {
                Button("Choose File...") {
                    chooseFile()
                }
                .buttonStyle(.bordered)

                Spacer()

                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.bordered)

                Button("Import") {
                    importKey()
                }
                .buttonStyle(.borderedProminent)
                .disabled(keyText.isEmpty || isImporting)
            }
        }
        .padding()
        .frame(width: 500)
    }

    // MARK: - Actions

    private func importKey() {
        errorMessage = nil
        isImporting = true

        do {
            let nick = nickname.isEmpty ? nil : nickname
            _ = try keyManager.importArmoredKey(keyText, nickname: nick)
            isPresented = false
        } catch {
            errorMessage = error.localizedDescription
        }

        isImporting = false
    }

    private func chooseFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.data]  // Allow all files
        panel.message = "Select a PGP key file"

        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try Data(contentsOf: url)
                if let string = String(data: data, encoding: .utf8) {
                    keyText = string
                } else {
                    // Try to read as binary and armor it
                    errorMessage = "Binary key import not yet supported. Please use ASCII-armored keys."
                }
            } catch {
                errorMessage = "Could not read file: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ImportKeyView(isPresented: .constant(true))
        .environmentObject(KeyManager())
}
