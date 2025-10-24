import PGPCore
import SwiftUI

/// Encrypt messages for your friends!
/// Turn plain text into crypto-gibberish that only they can read
///
/// Partners: Hue & Aye @ 8b.is
struct EncryptView: View {
    @EnvironmentObject var keyManager: KeyManager

    /// The message to encrypt
    @State private var inputText = ""

    /// The encrypted result
    @State private var outputText = ""

    /// Selected recipient key
    @State private var selectedRecipient: PGPKeyPair?

    /// Error message if something goes wrong
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            // Instructions
            instructionsView

            // Recipient picker
            recipientPicker

            // Input text area
            textEditor(
                title: "Message to Encrypt",
                text: $inputText,
                placeholder: "Type or paste your secret message here...",
            )

            // Action buttons
            actionButtons

            // Output text area (if we have output)
            if !outputText.isEmpty {
                textEditor(
                    title: "Encrypted Message",
                    text: .constant(outputText),
                    placeholder: "",
                    readOnly: true,
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
            Text("Select a recipient and enter your message")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }

    // MARK: - Recipient Picker

    private var recipientPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Encrypt for:")
                .font(.caption)
                .foregroundColor(.secondary)

            if keyManager.encryptionKeys.isEmpty {
                Text("No keys available. Import or generate a key first!")
                    .font(.body)
                    .foregroundColor(.orange)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
            } else {
                Picker("Recipient", selection: $selectedRecipient) {
                    Text("Select a recipient...").tag(nil as PGPKeyPair?)
                    ForEach(keyManager.encryptionKeys) { key in
                        // Show emoji + name as a single text for proper display in Picker
                        Text("\(key.statusEmoji) \(key.nickname)")
                            .tag(key as PGPKeyPair?)
                    }
                }
                .labelsHidden()
            }
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 8) {
            Button(action: clearAll) {
                Label("Clear", systemImage: "xmark.circle")
                    .frame(minWidth: 80)
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)

            Spacer()

            Button(action: pasteFromClipboard) {
                Label("Paste", systemImage: "doc.on.clipboard")
                    .frame(minWidth: 80)
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)

            Button(action: encrypt) {
                Label("Encrypt", systemImage: "lock.fill")
                    .frame(minWidth: 100)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
            .disabled(inputText.isEmpty || selectedRecipient == nil)

            if !outputText.isEmpty {
                Button(action: copyToClipboard) {
                    Label("Copy Result", systemImage: "doc.on.doc")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
            }
        }
    }

    // MARK: - Actions

    private func encrypt() {
        guard let recipient = selectedRecipient else {
            errorMessage = "Please select a recipient"
            return
        }

        errorMessage = nil

        do {
            outputText = try keyManager.encrypt(text: inputText, for: recipient)
        } catch {
            errorMessage = error.localizedDescription
            outputText = ""
        }
    }

    private func clearAll() {
        inputText = ""
        outputText = ""
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

        // Success notification - future enhancement
    }

    // MARK: - Helper Views

    private func textEditor(
        title: String,
        text: Binding<String>,
        placeholder: String,
        readOnly: Bool = false,
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty, !placeholder.isEmpty {
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
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1),
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
    EncryptView()
        .environmentObject(KeyManager())
        .frame(width: 400, height: 600)
}
