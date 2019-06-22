//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct GPGKey: Codable, Equatable, Hashable {
    
    public var canCertify: Bool?
    public var canEncryptComms: Bool?
    public var canEncryptStorage: Bool?
    public var canSign: Bool?
    public var createdAt: Date?
    public var emails: [GPGKeyEmail]?
    public var expiresAt: Date?
    public var _id: Int64?
    public var keyId: String?
    public var primaryKeyId: String?
    public var publicKey: String?
    public var subkeys: [GPGKey]?
    
    public init(canCertify: Bool?, canEncryptComms: Bool?, canEncryptStorage: Bool?, canSign: Bool?, createdAt: Date?, emails: [GPGKeyEmail]?, expiresAt: Date?, _id: Int64?, keyId: String?, primaryKeyId: String?, publicKey: String?, subkeys: [GPGKey]?) { 
        self.canCertify = canCertify
        self.canEncryptComms = canEncryptComms
        self.canEncryptStorage = canEncryptStorage
        self.canSign = canSign
        self.createdAt = createdAt
        self.emails = emails
        self.expiresAt = expiresAt
        self._id = _id
        self.keyId = keyId
        self.primaryKeyId = primaryKeyId
        self.publicKey = publicKey
        self.subkeys = subkeys
    }
    
    public enum CodingKeys: String, CodingKey { 
        case canCertify = "can_certify"
        case canEncryptComms = "can_encrypt_comms"
        case canEncryptStorage = "can_encrypt_storage"
        case canSign = "can_sign"
        case createdAt = "created_at"
        case emails
        case expiresAt = "expires_at"
        case _id = "id"
        case keyId = "key_id"
        case primaryKeyId = "primary_key_id"
        case publicKey = "public_key"
        case subkeys
    }
}
