import SwiftUI
import PGPCore

/// Decrypt those secret messages!
/// Turn crypto-gibberish back into readable text
///
/// Partners: Hue & Aye @ 8b.is
struct DecryptView: View {
    @EnvironmentObject var keyManager: KeyManager

    /// The encrypted message
    @State private var inputText = ""

    /// The decrypted result
    @State private var outputText = ""

    /// Selected key to decrypt with
    @State private var selectedKey: PGPKeyPair?

    /// Passphrase for the private key
    @State private var passphrase = ""

    /// Error message if something goes wrong
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            // Instructions
            instructionsView

            // Key picker
            keyPicker

            // Passphrase field
            if selectedKey != nil {
                passphraseField
            }

            // Input text area
            textEditor(
                title: "Encrypted Message",
                text: $inputText,
                placeholder: "Paste the encrypted message here..."
            )

            // Action buttons
            actionButtons

            // Output text area (if we have output)
            if !outputText.isEmpty {
                textEditor(
                    title: "Decrypted Message",
                    text: .constant(outputText),
                    placeholder: "",
                    readOnly: true
                )
            }

            // Error message
            if let error = errorMessage {
                errorView(message: error)
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Instructions

    private var instructionsView: some View {
        HStack {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
            Text("Select your key, enter passphrase, and paste encrypted message")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }

    // MARK: - Key Picker

    private var keyPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Decrypt with:")
                .font(.caption)
                .foregroundColor(.secondary)

            if keyManager.signingKeys.isEmpty {
                Text("No private keys available. Generate or import a private key first!")
                    .font(.body)
                    .foregroundColor(.orange)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
            } else {
                Picker("Your Key", selection: $selectedKey) {
                    Text("Select your key...").tag(nil as PGPKeyPair?)
                    ForEach(keyManager.signingKeys) { key in
                        HStack {
                            Text(key.statusEmoji)
                            Text(key.nickname)
                        }.tag(key as PGPKeyPair?)
                    }
                }
                .labelsHidden()
            }
        }
    }

    // MARK: - Passphrase Field

    private var passphraseField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Passphrase")
                .font(.caption)
                .foregroundColor(.secondary)

            SecureField("Enter your passphrase", text: $passphrase)
                .textFieldStyle(.roundedBorder)
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack {
            Button(action: clearAll) {
                Label("Clear", systemImage: "xmark.circle")
            }
            .buttonStyle(.bordered)

            Spacer()

            Button(action: pasteFromClipboard) {
                Label("Paste", systemImage: "doc.on.clipboard")
            }
            .buttonStyle(.bordered)

            Button(action: decrypt) {
                Label("Decrypt", systemImage: "lock.open.fill")
            }
            .buttonStyle(.borderedProminent)
            .disabled(inputText.isEmpty || selectedKey == nil || passphrase.isEmpty)

            if !outputText.isEmpty {
                Button(action: copyToClipboard) {
                    Label("Copy Result", systemImage: "doc.on.doc")
                }
                .buttonStyle(.bordered)
            }
        }
    }

    // MARK: - Actions

    private func decrypt() {
        guard let key = selectedKey else {
            errorMessage = "Please select a key"
            return
        }

        guard !passphrase.isEmpty else {
            errorMessage = "Please enter your passphrase"
            return
        }

        errorMessage = nil

        do {
            outputText = try keyManager.decrypt(
                armoredMessage: inputText,
                using: key,
                passphrase: passphrase
            )
        } catch {
            errorMessage = error.localizedDescription
            outputText = ""
        }
    }

    private func clearAll() {
        inputText = ""
        outputText = ""
        passphrase = ""
        errorMessage = nil
    }

    private func pasteFromClipboard() {
        let pasteboard = NSPasteboard.general
        if let string = pasteboard.string(forType: .string) {
            inputText = string
        }
    }

    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(outputText, forType: .string)

        // TODO: Show success toast
    }

    // MARK: - Helper Views

    private func textEditor(
        title: String,
        text: Binding<String>,
        placeholder: String,
        readOnly: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty && !placeholder.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(8)
                }

                if readOnly {
                    ScrollView {
                        Text(text.wrappedValue)
                            .font(.system(.body, design: .monospaced))
                            .textSelection(.enabled)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                    }
                    .frame(height: 100)
                } else {
                    TextEditor(text: text)
                        .font(.system(.body, design: .monospaced))
                        .frame(height: 100)
                }
            }
            .background(Color(NSColor.textBackgroundColor))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
    }

    private func errorView(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
            Spacer()
        }
        .padding(8)
        .background(Color.red.opacity(0.1))
        .cornerRadius(6)
    }
}

// MARK: - Preview

#Preview {
    DecryptView()
        .environmentObject(KeyManager())
        .frame(width: 400, height: 600)
}
