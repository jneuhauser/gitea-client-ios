//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct DeployKey: Codable, Equatable, Hashable {
    public var createdAt: Date?
    public var fingerprint: String?
    public var _id: Int64?
    public var key: String?
    public var keyId: Int64?
    public var readOnly: Bool?
    public var repository: Repository?
    public var title: String?
    public var url: String?

    public init(createdAt: Date?, fingerprint: String?, _id: Int64?, key: String?, keyId: Int64?, readOnly: Bool?, repository: Repository?, title: String?, url: String?) {
        self.createdAt = createdAt
        self.fingerprint = fingerprint
        self._id = _id
        self.key = key
        self.keyId = keyId
        self.readOnly = readOnly
        self.repository = repository
        self.title = title
        self.url = url
    }

    public enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case fingerprint
        case _id = "id"
        case key
        case keyId = "key_id"
        case readOnly = "read_only"
        case repository
        case title
        case url
    }
}
