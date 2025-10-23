import Foundation
@_exported import ObjectivePGP

/// Represents a PGP key pair (public + private keys)
/// Partners: Hue & Aye @ 8b.is
public struct PGPKeyPair: Identifiable, Codable, Hashable {
    public let id: UUID
    private let keyData: Data
    public var nickname: String
    public let email: String
    public let createdDate: Date
    public let expirationDate: Date?
    public let hasPrivateKey: Bool
    public let fingerprint: String
    public let userIDs: [String]
    
    public init(from key: Key, nickname: String? = nil) throws {
        self.id = UUID()
        
        do {
            let data = try key.export(keyType: .public)
            self.keyData = data
        } catch {
            throw PGPError.invalidKeyFormat
        }
        
        if let publicKey = key.publicKey, let primaryUser = publicKey.primaryUser {
            // userID is a String in format "Name <email>" - extract email
            let userIDString = primaryUser.userID
            if let emailMatch = userIDString.range(of: "<(.+)>", options: .regularExpression) {
                self.email = String(userIDString[emailMatch]).replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
            } else {
                self.email = userIDString
            }
        } else {
            self.email = "unknown"
        }
        
        self.nickname = nickname ?? self.email
        self.createdDate = Date()
        self.expirationDate = key.expirationDate
        self.hasPrivateKey = key.isSecret
        self.fingerprint = key.publicKey?.fingerprint.description() ?? ""
        
        var ids: [String] = []
        if let users = key.publicKey?.users {
            for user in users {
                ids.append(user.userID)
            }
        }
        self.userIDs = ids
    }
    
    public init(id: UUID, keyData: Data, nickname: String, email: String, createdDate: Date, expirationDate: Date?, hasPrivateKey: Bool, fingerprint: String, userIDs: [String]) {
        self.id = id
        self.keyData = keyData
        self.nickname = nickname
        self.email = email
        self.createdDate = createdDate
        self.expirationDate = expirationDate
        self.hasPrivateKey = hasPrivateKey
        self.fingerprint = fingerprint
        self.userIDs = userIDs
    }
    
    public func getKey() throws -> Key {
        do {
            let keys = try ObjectivePGP.readKeys(from: keyData)
            guard let key = keys.first else {
                throw PGPError.noKeysFound
            }
            return key
        } catch {
            throw PGPError.noKeysFound
        }
    }
    
    public func exportArmored(includePrivate: Bool = false) throws -> String {
        let key = try getKey()
        do {
            let dataToExport = try key.export(keyType: .public)
            return Armor.armored(dataToExport, as: .publicKey)
        } catch {
            throw PGPError.encryptionFailed
        }
    }
    
    public var isExpired: Bool {
        guard let expiration = expirationDate else { return false }
        return expiration < Date()
    }
    
    public var isValid: Bool { !isExpired }
    
    public var shortFingerprint: String {
        let cleaned = fingerprint.replacingOccurrences(of: " ", with: "")
        guard cleaned.count >= 16 else { return cleaned }
        let startIndex = cleaned.index(cleaned.endIndex, offsetBy: -16)
        return String(cleaned[startIndex...])
    }
    
    public var keyTypeDescription: String {
        hasPrivateKey ? "Private Key" : "Public Key"
    }
    
    public var statusEmoji: String {
        if isExpired { return "⏰" }
        if hasPrivateKey { return "🔐" }
        return "🔓"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: PGPKeyPair, rhs: PGPKeyPair) -> Bool {
        lhs.id == rhs.id
    }
}

public enum PGPError: LocalizedError {
    case invalidKeyFormat, noKeysFound, privateKeyRequired, invalidInput, invalidOutput
    case encryptionFailed, decryptionFailed, signingFailed, verificationFailed
    
    public var errorDescription: String? {
        switch self {
        case .invalidKeyFormat: return "Invalid key format"
        case .noKeysFound: return "No keys found"
        case .privateKeyRequired: return "Private key required"
        case .invalidInput: return "Invalid input"
        case .invalidOutput: return "Invalid output"
        case .encryptionFailed: return "Encryption failed"
        case .decryptionFailed: return "Decryption failed"
        case .signingFailed: return "Signing failed"
        case .verificationFailed: return "Verification failed"
        }
    }
}
