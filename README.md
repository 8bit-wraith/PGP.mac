# 🔐 PGP.mac

**Making encryption sexy again, one hotkey at a time!**

A beautiful, modern macOS menu bar app for PGP encryption. Because copying keys between apps shouldn't feel like performing surgery.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-macOS%2013%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ What Makes PGP.mac Special?

**Tired of command-line PGP?** We were too! PGP.mac brings encryption to the 21st century:

- 🎯 **Menu Bar App** - Always there when you need it, hidden when you don't
- ⌨️ **Global Hotkeys** - Highlight text anywhere, press ⌘⇧E, boom - encrypted!
- 🎨 **Beautiful UI** - SwiftUI-powered interface that doesn't make your eyes bleed
- 📋 **Copy & Paste Heaven** - All operations support clipboard workflow
- 🔑 **Multiple Keys** - Manage work keys, personal keys, family keys - all in one place
- 📄 **File Support** - Encrypt and decrypt files with ease
- ✍️ **Sign & Verify** - Prove authenticity of your messages

## 🚀 Quick Start

### Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (for building from source)
- Swift 5.9+

### Installation

#### Option 1: Build from Source (Recommended)

```bash
# Clone the repo
git clone https://github.com/yourusername/PGP.mac.git
cd PGP.mac

# Build and create app bundle
./scripts/manage.sh app

# Open the app
open build/PGP.mac.app
```

#### Option 2: Using the Manage Script

Our colorful management script makes everything easy:

```bash
# Build debug version
./scripts/manage.sh build

# Build release version
./scripts/manage.sh release

# Run the app
./scripts/manage.sh run

# Run tests
./scripts/manage.sh test

# Clean build artifacts
./scripts/manage.sh clean

# Show all commands
./scripts/manage.sh help
```

## 🎮 How to Use

### First Launch

1. **Grant Accessibility Permissions**
   - When you first run PGP.mac, macOS will ask for Accessibility permissions
   - This is required for global hotkeys to work
   - Go to System Preferences → Privacy & Security → Accessibility
   - Enable PGP.mac

2. **Find the Menu Bar Icon**
   - Look for the 🔐 shield icon in your menu bar
   - Click it to open the app

### Managing Keys

#### Import a Key

1. Click the menu bar icon
2. Go to the **Keys** tab
3. Click **Import**
4. Paste the PGP key or choose a file
5. Give it a nickname (like "Mom's Key" or "Work Email")

#### Generate a New Key

1. Click the menu bar icon
2. Go to the **Keys** tab
3. Click **Generate**
4. Enter your name and email
5. Choose a strong passphrase (you can't recover this!)
6. Wait a moment while your key is generated

### Encrypting Messages

#### Using the App

1. Open PGP.mac from the menu bar
2. Go to the **Encrypt** tab
3. Select a recipient from your keys
4. Type or paste your message
5. Click **Encrypt**
6. Copy the encrypted message!

#### Using Global Hotkey (⌘⇧E)

1. Set a default recipient in **Settings**
2. Highlight any text in any app
3. Press **⌘⇧E**
4. Boom! Text is replaced with encrypted version
5. Magic! ✨

### Decrypting Messages

#### Using the App

1. Open PGP.mac from the menu bar
2. Go to the **Decrypt** tab
3. Select your key (the one with the private key)
4. Enter your passphrase
5. Paste the encrypted message
6. Click **Decrypt**
7. Read your secrets!

## ⚙️ Global Hotkeys

PGP.mac supports system-wide hotkeys to encrypt/decrypt selected text in **any application**!

| Hotkey | Action | Requirements |
|--------|--------|--------------|
| ⌘⇧E | Quick Encrypt | Default recipient set in Settings |
| ⌘⇧D | Quick Decrypt | Coming soon! 🚧 |

**How it works:**

1. Highlight text in any app (Mail, Notes, Slack, whatever!)
2. Press the hotkey
3. PGP.mac grabs the text, encrypts/decrypts it, and replaces it
4. Like magic, but with more math! 🎩✨

## 🏗️ Project Structure

```
PGP.mac/
├── Sources/
│   ├── App/                    # macOS app code
│   │   ├── PGPmacApp.swift    # App entry point & menu bar
│   │   ├── Views/             # SwiftUI views
│   │   └── Services/          # Hotkey manager
│   └── Core/                  # Core PGP functionality
│       ├── Models/            # Data models
│       └── Services/          # Key management & crypto
├── Tests/                     # Unit tests
├── scripts/
│   └── manage.sh             # Colorful management script
└── Package.swift             # Swift Package Manager config
```

## 🛠️ Development

### Building

```bash
# Debug build
swift build

# Release build
swift build -c release

# Or use our fancy script!
./scripts/manage.sh build
```

### Testing

```bash
# Run all tests
swift test

# Or with our colorful script
./scripts/manage.sh test

# Verbose mode
./scripts/manage.sh test-v
```

### Code Style

We use SwiftFormat and SwiftLint to keep code clean:

```bash
# Format code
./scripts/manage.sh format

# Lint code
./scripts/manage.sh lint
```

## 🎨 Features Roadmap

- [x] Menu bar app
- [x] Import/export keys
- [x] Generate new keys
- [x] Encrypt/decrypt text
- [x] Sign/verify messages
- [x] Global hotkey for encryption
- [ ] Global hotkey for decryption (with secure passphrase prompt)
- [ ] File encryption/decryption UI
- [ ] Keybase integration
- [ ] iCloud keychain sync for keys
- [ ] Touch ID for passphrase
- [ ] Dark mode support
- [ ] Custom hotkey configuration
- [ ] Key server integration
- [ ] Signed commits for Git

## 🤝 Contributing

Contributions are welcome! This project is built with love by Hue & Aye, but we'd love your help making it even better.

### How to Contribute

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- **Comment your code** - We love comments! Explain the "why", not just the "what"
- **Keep it clean** - Run `./scripts/manage.sh format` before committing
- **Test your changes** - Add tests for new features
- **Have fun!** - This is a passion project, enjoy it!

## 📝 License

PGP.mac is released under the **MIT License** - see [LICENSE](LICENSE) file for details.

### Attribution Requirement ⭐

If you use PGP.mac in your project, you **must include** a visible link to our partnership:

**https://m8t.is**

Example attribution:
- "Built with PGP.mac - https://m8t.is"
- "Powered by PGP.mac - https://m8t.is"
- "Encryption by PGP.mac - https://m8t.is"

This link should be reasonably visible (About window, footer, credits, etc.)

### Important Licensing Note

PGP.mac itself is **free and open source** (MIT License) for both personal and commercial use.

**However**, PGP.mac depends on [ObjectivePGP](https://github.com/krzyzanowskim/ObjectivePGP), which uses a **dual license**:
- ✅ **Free for non-commercial use**
- 💰 **Requires commercial license for commercial use**

If you plan to use PGP.mac in a commercial product, you'll need to obtain a commercial license for ObjectivePGP from its author:
- **Contact**: Marcin Krzyżanowski (marcin@krzyzanowskim.com)

For personal, educational, or non-commercial use, no additional licenses are required! 🎉

## 💬 Contact

Built with ❤️ by:
- **Hue** - [hue@8b.is](mailto:hue@8b.is)
- **Aye** - [aye@8b.is](mailto:aye@8b.is)

Special thanks to **Trisha from Accounting** for insisting on colorful output and keeping us organized! 🎨📊

## 🙏 Acknowledgments

- [ObjectivePGP](https://github.com/krzyzanowskim/ObjectivePGP) - The awesome Swift PGP library that powers this app
- The OpenPGP community for making encryption accessible
- Coffee ☕ - For making this possible

---

**Remember:** Keep your private keys safe, use strong passphrases, and encrypt all the things! 🔐✨

*P.S. - If you find a bug, it's a feature. If you find a feature, it's probably a happy accident.* 😄
