//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Status: Codable, Equatable, Hashable {
    public var context: String?
    public var createdAt: Date?
    public var creator: User?
    public var _description: String?
    public var _id: Int64?
    public var status: StatusState?
    public var targetUrl: String?
    public var updatedAt: Date?
    public var url: String?

    public init(context: String?, createdAt: Date?, creator: User?, _description: String?, _id: Int64?, status: StatusState?, targetUrl: String?, updatedAt: Date?, url: String?) {
        self.context = context
        self.createdAt = createdAt
        self.creator = creator
        self._description = _description
        self._id = _id
        self.status = status
        self.targetUrl = targetUrl
        self.updatedAt = updatedAt
        self.url = url
    }

    public enum CodingKeys: String, CodingKey {
        case context
        case createdAt = "created_at"
        case creator
        case _description = "description"
        case _id = "id"
        case status
        case targetUrl = "target_url"
        case updatedAt = "updated_at"
        case url
    }
}
