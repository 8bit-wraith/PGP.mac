import SwiftUI

/// About PGP.mac window
/// Shows version, credits, and licensing information
///
/// Partners: Hue & Aye @ 8b.is
struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            // App Icon & Title
            headerSection

            Divider()

            // Scrollable content area
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Version Info
                    versionSection

                    Divider()

                    // Credits
                    creditsSection

                    Divider()

                    // Licensing Information
                    licensingSection

                    Divider()

                    // Acknowledgments
                    acknowledgementsSection
                }
                .padding()
            }
            .frame(height: 400)

            // Close button
            HStack {
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(width: 550)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("PGP.mac")
                .font(.title)
                .fontWeight(.bold)

            Text("Making encryption accessible, one hotkey at a time!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Version Info

    private var versionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Version Information")

            infoRow(label: "Version", value: "1.0.0")
            infoRow(label: "Build", value: "2025.01")
            infoRow(label: "Platform", value: "macOS 13.0+")
            infoRow(label: "Swift", value: "5.9+")
        }
    }

    // MARK: - Credits

    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Credits")

            Text("Built with ❤️ by:")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("8bit-Wraith/Hue")
                        .fontWeight(.semibold)
                    Text("hue@8b.is")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Claude (Aye)")
                        .fontWeight(.semibold)
                    Text("Anthropic AI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)

            Text("Special thanks to Trisha from Accounting for keeping us organized! 🎨📊")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
                .padding(.top, 4)
        }
    }

    // MARK: - Licensing

    private var licensingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("License")

            // PGP.mac License
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("PGP.mac")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("MIT License")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }

                Text("Free for all uses - personal and commercial")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("Copyright © 2025 8bit-Wraith/Hue (8b.is) & Claude (Anthropic)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
            .cornerRadius(8)

            // ObjectivePGP License
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("ObjectivePGP")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Dual License")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(4)
                }

                Group {
                    HStack(spacing: 4) {
                        Text("✅")
                        Text("Free for non-commercial use")
                            .font(.caption)
                    }

                    HStack(spacing: 4) {
                        Text("⚠️")
                        Text("Commercial license required for commercial use")
                            .font(.caption)
                    }
                }

                Text("Copyright © 2014-2023 Marcin Krzyżanowski")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)

                Text("For commercial use, contact: marcin@krzyzanowskim.com")
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .padding(.top, 2)
            }
            .padding()
            .background(Color.orange.opacity(0.05))
            .cornerRadius(8)

            // Summary
            Text(
                "💡 Summary: PGP.mac is free for everyone. " +
                "If using commercially, you'll need a commercial license for ObjectivePGP."
            )
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)

            // Attribution Requirement
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "link.circle.fill")
                        .foregroundColor(.purple)
                    Text("Attribution Requirement")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Text("If you use PGP.mac in your project, you must include a link to our partnership:")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Button(action: {
                    NSWorkspace.shared.open(URL(string: "https://m8t.is")!)
                }) {
                    HStack {
                        Image(systemName: "globe")
                        Text("https://m8t.is")
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.purple.opacity(0.15))
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)

                Text("Example: \"Built with PGP.mac - https://m8t.is\"")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .italic()
            }
            .padding()
            .background(Color.purple.opacity(0.05))
            .cornerRadius(8)
        }
    }

    // MARK: - Acknowledgements

    private var acknowledgementsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Acknowledgements")

            VStack(alignment: .leading, spacing: 6) {
                acknowledgementRow(
                    name: "ObjectivePGP",
                    description: "Swift PGP library",
                    link: "github.com/krzyzanowskim/ObjectivePGP"
                )

                acknowledgementRow(
                    name: "OpenPGP Community",
                    description: "Making encryption accessible"
                )

                acknowledgementRow(
                    name: "Coffee",
                    description: "For making this possible ☕"
                )
            }
        }
    }

    // MARK: - Helper Views

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }

    private func acknowledgementRow(name: String, description: String, link: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .fontWeight(.semibold)
                .font(.subheadline)

            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)

            if let link = link {
                Text(link)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Preview

#Preview {
    AboutView()
}
