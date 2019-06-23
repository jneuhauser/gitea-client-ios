//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Comment: Codable, Equatable, Hashable {
    public var body: String?
    public var createdAt: Date?
    public var htmlUrl: String?
    public var _id: Int64?
    public var issueUrl: String?
    public var pullRequestUrl: String?
    public var updatedAt: Date?
    public var user: User?

    public init(body: String?, createdAt: Date?, htmlUrl: String?, _id: Int64?, issueUrl: String?, pullRequestUrl: String?, updatedAt: Date?, user: User?) {
        self.body = body
        self.createdAt = createdAt
        self.htmlUrl = htmlUrl
        self._id = _id
        self.issueUrl = issueUrl
        self.pullRequestUrl = pullRequestUrl
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey {
        case body
        case createdAt = "created_at"
        case htmlUrl = "html_url"
        case _id = "id"
        case issueUrl = "issue_url"
        case pullRequestUrl = "pull_request_url"
        case updatedAt = "updated_at"
        case user
    }
}
