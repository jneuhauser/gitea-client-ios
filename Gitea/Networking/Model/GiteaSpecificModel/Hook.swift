//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Hook: Codable, Equatable, Hashable {
    public var active: Bool?
    public var config: [String: String]?
    public var createdAt: Date?
    public var events: [String]?
    public var _id: Int64?
    public var type: String?
    public var updatedAt: Date?

    public init(active: Bool?, config: [String: String]?, createdAt: Date?, events: [String]?, _id: Int64?, type: String?, updatedAt: Date?) {
        self.active = active
        self.config = config
        self.createdAt = createdAt
        self.events = events
        self._id = _id
        self.type = type
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey {
        case active
        case config
        case createdAt = "created_at"
        case events
        case _id = "id"
        case type
        case updatedAt = "updated_at"
    }
}
