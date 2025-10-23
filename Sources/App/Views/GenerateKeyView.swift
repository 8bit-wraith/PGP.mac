import SwiftUI
import PGPCore

/// Generate a brand new PGP key pair
/// Your fresh crypto identity awaits!
///
/// Partners: Hue & Aye @ 8b.is
struct GenerateKeyView: View {
    @EnvironmentObject var keyManager: KeyManager
    @Binding var isPresented: Bool

    @State private var name = ""
    @State private var email = ""
    @State private var passphrase = ""
    @State private var confirmPassphrase = ""
    @State private var keySize = 4096
    @State private var errorMessage: String?
    @State private var isGenerating = false

    private let keySizes = [2048, 3072, 4096]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Generate New Key Pair")
                .font(.title2)
                .fontWeight(.bold)

            // Instructions
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    Text("This will create a new PGP key pair (public + private)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }

                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Keep your passphrase safe! You can't recover it if lost.")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Spacer()
                }
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(8)

            // Form fields
            VStack(spacing: 12) {
                // Name
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Name")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("e.g., Hue Human", text: $name)
                        .textFieldStyle(.roundedBorder)
                }

                // Email
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email Address")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("hue@8b.is", text: $email)
                        .textFieldStyle(.roundedBorder)
                }

                // Passphrase
                VStack(alignment: .leading, spacing: 4) {
                    Text("Passphrase")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    SecureField("Enter a strong passphrase", text: $passphrase)
                        .textFieldStyle(.roundedBorder)
                }

                // Confirm Passphrase
                VStack(alignment: .leading, spacing: 4) {
                    Text("Confirm Passphrase")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    SecureField("Re-enter passphrase", text: $confirmPassphrase)
                        .textFieldStyle(.roundedBorder)
                }

                // Key size
                VStack(alignment: .leading, spacing: 4) {
                    Text("Key Size")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Picker("Key Size", selection: $keySize) {
                        ForEach(keySizes, id: \.self) { size in
                            Text("\(size) bits").tag(size)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(keySizeDescription)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
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
                Spacer()

                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.bordered)

                Button(isGenerating ? "Generating..." : "Generate Key") {
                    generateKey()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid || isGenerating)
            }
        }
        .padding()
        .frame(width: 500)
    }

    // MARK: - Computed Properties

    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !passphrase.isEmpty &&
        passphrase == confirmPassphrase &&
        email.contains("@")
    }

    private var keySizeDescription: String {
        switch keySize {
        case 2048:
            return "Fast, good for most uses"
        case 3072:
            return "Balanced security and performance"
        case 4096:
            return "Maximum security (recommended)"
        default:
            return ""
        }
    }

    // MARK: - Actions

    private func generateKey() {
        errorMessage = nil

        guard passphrase == confirmPassphrase else {
            errorMessage = "Passphrases don't match"
            return
        }

        guard passphrase.count >= 8 else {
            errorMessage = "Passphrase must be at least 8 characters"
            return
        }

        isGenerating = true

        // Run on background thread since key generation can take a moment
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                _ = try keyManager.generateKeyPair(
                    name: name,
                    email: email,
                    passphrase: passphrase,
                    keySize: keySize
                )

                DispatchQueue.main.async {
                    isPresented = false
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    isGenerating = false
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    GenerateKeyView(isPresented: .constant(true))
        .environmentObject(KeyManager())
}
