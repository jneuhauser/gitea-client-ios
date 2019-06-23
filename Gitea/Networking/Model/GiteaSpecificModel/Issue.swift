//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Issue: Codable, Equatable, Hashable, IssuePullRequestData {
    public var assignee: User?
    public var assignees: [User]?
    public var body: String?
    public var closedAt: Date?
    public var comments: Int64?
    public var createdAt: Date?
    public var dueDate: Date?
    public var _id: Int64?
    public var labels: [Label]?
    public var milestone: Milestone?
    public var number: Int64?
    public var pullRequest: PullRequestMeta?
    public var state: StateType?
    public var title: String?
    public var updatedAt: Date?
    public var url: String?
    public var user: User?

    public init(assignee: User?, assignees: [User]?, body: String?, closedAt: Date?, comments: Int64?, createdAt: Date?, dueDate: Date?, _id: Int64?, labels: [Label]?, milestone: Milestone?, number: Int64?, pullRequest: PullRequestMeta?, state: StateType?, title: String?, updatedAt: Date?, url: String?, user: User?) {
        self.assignee = assignee
        self.assignees = assignees
        self.body = body
        self.closedAt = closedAt
        self.comments = comments
        self.createdAt = createdAt
        self.dueDate = dueDate
        self._id = _id
        self.labels = labels
        self.milestone = milestone
        self.number = number
        self.pullRequest = pullRequest
        self.state = state
        self.title = title
        self.updatedAt = updatedAt
        self.url = url
        self.user = user
    }

    public enum CodingKeys: String, CodingKey {
        case assignee
        case assignees
        case body
        case closedAt = "closed_at"
        case comments
        case createdAt = "created_at"
        case dueDate = "due_date"
        case _id = "id"
        case labels
        case milestone
        case number
        case pullRequest = "pull_request"
        case state
        case title
        case updatedAt = "updated_at"
        case url
        case user
    }
}
