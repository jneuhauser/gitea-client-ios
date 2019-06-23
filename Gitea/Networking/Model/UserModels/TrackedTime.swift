//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct TrackedTime: Codable, Equatable, Hashable {
    public var created: Date?
    public var _id: Int64?
    public var issueId: Int64?
    public var time: Int64?
    public var userId: Int64?

    public init(created: Date?, _id: Int64?, issueId: Int64?, time: Int64?, userId: Int64?) {
        self.created = created
        self._id = _id
        self.issueId = issueId
        self.time = time
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey {
        case created
        case _id = "id"
        case issueId = "issue_id"
        case time
        case userId = "user_id"
    }
}
