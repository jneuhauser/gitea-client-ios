//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct PublicKey: Codable, Equatable, Hashable {
    public var createdAt: Date?
    public var fingerprint: String?
    public var _id: Int64?
    public var key: String?
    public var keyType: String?
    public var readOnly: Bool?
    public var title: String?
    public var url: String?
    public var user: User?

    public init(createdAt: Date?, fingerprint: String?, _id: Int64?, key: String?, keyType: String?, readOnly: Bool?, title: String?, url: String?, user: User?) {
        self.createdAt = createdAt
        self.fingerprint = fingerprint
        self._id = _id
        self.key = key
        self.keyType = keyType
        self.readOnly = readOnly
        self.title = title
        self.url = url
        self.user = user
    }

    public enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case fingerprint
        case _id = "id"
        case key
        case keyType = "key_type"
        case readOnly = "read_only"
        case title
        case url
        case user
    }
}
