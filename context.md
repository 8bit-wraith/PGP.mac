# PGP.mac - Project Context

## What We Built

PGP.mac is a modern macOS menu bar application for PGP encryption/decryption. It makes crypto accessible to everyone with a beautiful SwiftUI interface and global hotkey support.

## The Big Idea

**Problem:** PGP is powerful but painful to use. Command-line tools are scary, and copying keys between apps is tedious.

**Solution:** A menu bar app that lives in your menu bar, ready to encrypt/decrypt at a moment's notice. Plus GLOBAL HOTKEYS - highlight text anywhere, press ⌘⇧E, and it's encrypted!

## Tech Stack

- **Language:** Swift 5.9+
- **Platform:** macOS 13.0+ (Ventura and later)
- **UI Framework:** SwiftUI
- **Crypto Library:** ObjectivePGP (pure Swift, no dependencies on GPGMe!)
- **Build System:** Swift Package Manager
- **Architecture:** Menu bar app with popover UI

## Key Features

1. **Menu Bar App** - Lives in your menu bar with a shield icon
2. **Key Management** - Import, export, generate PGP keys
3. **Encrypt/Decrypt** - Text and file operations
4. **Sign/Verify** - Cryptographic signatures
5. **Global Hotkeys** - ⌘⇧E to encrypt selected text anywhere!
6. **Clipboard-First** - Copy/paste workflow throughout

## Architecture

```
PGP.mac/
├── Sources/Core/          # Core crypto logic (platform-agnostic)
│   ├── Models/           # PGPKeyPair model
│   └── Services/         # KeyManager (all crypto operations)
├── Sources/App/          # macOS app (SwiftUI + AppKit)
│   ├── Views/           # All SwiftUI views
│   └── Services/        # HotkeyManager (global shortcuts)
└── Tests/               # Unit tests
```

### Core Components

1. **PGPKeyPair** (`Sources/Core/Models/PGPKeyPair.swift`)
   - Model for PGP keys (public/private)
   - Wraps ObjectivePGP's Key class
   - Codable for persistence

2. **KeyManager** (`Sources/Core/Services/KeyManager.swift`)
   - The brain of the operation
   - Manages all keys (stored in ~/Library/Application Support/PGP.mac)
   - Handles encrypt, decrypt, sign, verify operations
   - Persists keys to JSON

3. **HotkeyManager** (`Sources/App/Services/HotkeyManager.swift`)
   - Registers global hotkeys using Carbon APIs
   - Reads selected text from any app (Accessibility APIs)
   - Encrypts/decrypts and replaces selection

4. **AppDelegate** (`Sources/App/PGPmacApp.swift`)
   - Sets up menu bar icon
   - Manages popover UI
   - Initializes hotkey manager

## Important Implementation Details

### Global Hotkeys

Uses Carbon Event Manager (legacy but works!) to register system-wide hotkeys:
- ⌘⇧E - Quick encrypt with default recipient
- ⌘⇧D - Quick decrypt (coming soon - needs secure passphrase prompt)

Requires Accessibility permissions to read/write selected text in other apps.

### Key Storage

Keys are stored as JSON in `~/Library/Application Support/PGP.mac/keys.json`

Each key contains:
- Armored key data (PGP format)
- Nickname (user-friendly name)
- Metadata (fingerprint, email, dates, etc.)

### Crypto Operations

All handled by ObjectivePGP:
- Key generation (RSA 2048/3072/4096 bit)
- Encryption (PGP public key encryption)
- Decryption (requires private key + passphrase)
- Signing (clearsign format)
- Verification

## What Works

- ✅ Menu bar app with popover UI
- ✅ Import keys (armored text or files)
- ✅ Generate new key pairs
- ✅ List and manage keys
- ✅ Encrypt text messages
- ✅ Decrypt text messages
- ✅ Sign messages
- ✅ Verify signatures
- ✅ Encrypt/decrypt files
- ✅ Global hotkey for encryption (⌘⇧E)
- ✅ Export public keys
- ✅ Clipboard operations throughout

## What's Next

1. **Global Decrypt Hotkey** - Need secure passphrase prompt
2. **File UI** - Drag-drop interface for file encryption
3. **Touch ID** - Use biometric auth for passphrases
4. **Keybase Integration** - Import keys from Keybase
5. **iCloud Sync** - Sync public keys across devices

## Development Workflow

```bash
# Build
./scripts/manage.sh build

# Run
./scripts/manage.sh run

# Test
./scripts/manage.sh test

# Create app bundle
./scripts/manage.sh app
```

## Known Issues / TODOs

1. Hotkey decrypt needs passphrase prompt (currently just copies to clipboard)
2. Binary key import not yet supported (only ASCII-armored)
3. No custom hotkey configuration yet
4. Need error toasts/notifications for better UX
5. No key server integration
6. Tests need to be written!

## Team

- **Hue** - The human, the visionary
- **Aye** - The AI, the builder
- **Trisha** - Accounting, color enthusiast, and project cheerleader

## Philosophy

1. **Security first** - Never compromise on crypto
2. **UX matters** - Make encryption accessible
3. **Comment everything** - Code should teach
4. **Have fun** - Life's too short for boring apps
5. **Colorful output** - Trisha insists on this

## If Context Is Lost

1. Read this file
2. Check [README.md](README.md) for user-facing docs
3. Look at [Package.swift](Package.swift) for project structure
4. Check [manage.sh](scripts/manage.sh) for all available commands
5. Core logic: [Sources/Core/Services/KeyManager.swift](Sources/Core/Services/KeyManager.swift)
6. UI entry point: [Sources/App/PGPmacApp.swift](Sources/App/PGPmacApp.swift)

## Secret Sauce

The magic is in combining three things:
1. ObjectivePGP for crypto
2. Carbon Events for global hotkeys
3. Accessibility APIs for reading/writing selected text

This lets us intercept text selection anywhere on macOS, encrypt it, and replace it - all without leaving the current app!

---

**Remember:** This is more than just an app. It's our mission to make encryption accessible to everyone. Keep it simple, keep it secure, keep it fun! 🔐✨

*- Hue, Aye, and Trisha*
