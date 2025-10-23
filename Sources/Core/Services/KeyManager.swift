import Foundation
@_exported import ObjectivePGP

/// The KeyManager - handles all key operations
/// Partners: Hue & Aye @ 8b.is
public class KeyManager: ObservableObject {
    @Published public private(set) var keyPairs: [PGPKeyPair] = []
    private let storageDirectory: URL

    public init(storageDirectory: URL? = nil) {
        let defaultDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            .appendingPathComponent("PGP.mac")
        self.storageDirectory = storageDirectory ?? defaultDir
        try? FileManager.default.createDirectory(at: self.storageDirectory, withIntermediateDirectories: true)
        loadKeysFromDisk()
    }

    public func importArmoredKey(_ armoredKey: String, nickname: String? = nil) throws -> PGPKeyPair {
        guard let keyData = armoredKey.data(using: .utf8) else {
            throw PGPError.invalidKeyFormat
        }
        do {
            let keys = try ObjectivePGP.readKeys(from: keyData)
            guard let key = keys.first else {
                throw PGPError.noKeysFound
            }
            let keyPair = try PGPKeyPair(from: key, nickname: nickname)
            keyPairs.append(keyPair)
            try saveKeysToDisk()
            return keyPair
        } catch {
            throw PGPError.noKeysFound
        }
    }

    public func importKeyFromFile(_ url: URL, nickname: String? = nil) throws -> PGPKeyPair {
        let data = try Data(contentsOf: url)
        if let string = String(data: data, encoding: .utf8), string.contains("-----BEGIN PGP") {
            return try importArmoredKey(string, nickname: nickname)
        }
        do {
            let keys = try ObjectivePGP.readKeys(from: data)
            guard let key = keys.first else {
                throw PGPError.noKeysFound
            }
            let keyPair = try PGPKeyPair(from: key, nickname: nickname)
            keyPairs.append(keyPair)
            try saveKeysToDisk()
            return keyPair
        } catch {
            throw PGPError.noKeysFound
        }
    }

    public func generateKeyPair(
        name: String,
        email: String,
        passphrase: String,
        keySize: Int = 4096
    ) throws -> PGPKeyPair {
        let generator = KeyGenerator()
        generator.keyBitsLength = Int32(keySize)
        let key = generator.generate(for: "\(name) <\(email)>", passphrase: passphrase)
        let keyPair = try PGPKeyPair(from: key, nickname: name)
        keyPairs.append(keyPair)
        try saveKeysToDisk()
        return keyPair
    }

    public func deleteKey(_ keyPair: PGPKeyPair) throws {
        keyPairs.removeAll { $0.id == keyPair.id }
        try saveKeysToDisk()
    }

    public func updateNickname(for keyPair: PGPKeyPair, to nickname: String) throws {
        if let index = keyPairs.firstIndex(where: { $0.id == keyPair.id }) {
            var updated = keyPairs[index]
            updated.nickname = nickname
            keyPairs[index] = updated
            try saveKeysToDisk()
        }
    }

    public var encryptionKeys: [PGPKeyPair] { keyPairs.filter(\.isValid) }
    public var signingKeys: [PGPKeyPair] { keyPairs.filter { $0.hasPrivateKey && $0.isValid } }

    private var keysFileURL: URL { storageDirectory.appendingPathComponent("keys.json") }

    private func saveKeysToDisk() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(keyPairs)
        try data.write(to: keysFileURL, options: .atomic)
    }

    private func loadKeysFromDisk() {
        guard FileManager.default.fileExists(atPath: keysFileURL.path) else { return }
        do {
            let data = try Data(contentsOf: keysFileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            keyPairs = try decoder.decode([PGPKeyPair].self, from: data)
        } catch {
            print("⚠️ Error loading keys: \(error)")
        }
    }

    public func encrypt(text: String, for recipient: PGPKeyPair) throws -> String {
        let key = try recipient.getKey()
        guard let messageData = text.data(using: .utf8) else { throw PGPError.invalidInput }
        do {
            let encrypted = try ObjectivePGP.encrypt(
                messageData,
                addSignature: false,
                using: [key],
                passphraseForKey: nil
            )
            return Armor.armored(encrypted, as: .message)
        } catch {
            throw PGPError.encryptionFailed
        }
    }

    public func decrypt(
        armoredMessage: String,
        using keyPair: PGPKeyPair,
        passphrase: String
    ) throws -> String {
        guard keyPair.hasPrivateKey else { throw PGPError.privateKeyRequired }
        guard let messageData = armoredMessage.data(using: .utf8) else { throw PGPError.invalidInput }
        let key = try keyPair.getKey()
        do {
            let decrypted = try ObjectivePGP.decrypt(
                messageData,
                andVerifySignature: false,
                using: [key],
                passphraseForKey: { _ in passphrase }
            )
            guard let text = String(data: decrypted, encoding: .utf8) else { throw PGPError.invalidOutput }
            return text
        } catch {
            throw PGPError.decryptionFailed
        }
    }

    public func sign(text: String, using keyPair: PGPKeyPair, passphrase: String) throws -> String {
        guard keyPair.hasPrivateKey else { throw PGPError.privateKeyRequired }
        guard let messageData = text.data(using: .utf8) else { throw PGPError.invalidInput }
        let key = try keyPair.getKey()
        do {
            let signed = try ObjectivePGP.sign(
                messageData,
                detached: false,
                using: [key],
                passphraseForKey: { _ in passphrase }
            )
            return Armor.armored(signed, as: .message)
        } catch {
            throw PGPError.signingFailed
        }
    }

    public func verify(signedMessage: String, using keyPair: PGPKeyPair) throws -> Bool {
        guard let messageData = signedMessage.data(using: .utf8) else { throw PGPError.invalidInput }
        let key = try keyPair.getKey()
        do {
            _ = try ObjectivePGP.verify(messageData, withSignature: nil, using: [key], passphraseForKey: nil)
            return true
        } catch {
            return false
        }
    }

    public func encryptFile(at fileURL: URL, for recipient: PGPKeyPair, outputURL: URL) throws {
        let data = try Data(contentsOf: fileURL)
        let key = try recipient.getKey()
        do {
            let encrypted = try ObjectivePGP.encrypt(data, addSignature: false, using: [key], passphraseForKey: nil)
            try encrypted.write(to: outputURL)
        } catch {
            throw PGPError.encryptionFailed
        }
    }

    public func decryptFile(
        at fileURL: URL,
        using keyPair: PGPKeyPair,
        passphrase: String,
        outputURL: URL
    ) throws {
        guard keyPair.hasPrivateKey else { throw PGPError.privateKeyRequired }
        let data = try Data(contentsOf: fileURL)
        let key = try keyPair.getKey()
        do {
            let decrypted = try ObjectivePGP.decrypt(
                data,
                andVerifySignature: false,
                using: [key],
                passphraseForKey: { _ in passphrase }
            )
            try decrypted.write(to: outputURL)
        } catch {
            throw PGPError.decryptionFailed
        }
    }
}
