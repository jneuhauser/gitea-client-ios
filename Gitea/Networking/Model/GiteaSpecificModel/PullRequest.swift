//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct PullRequest: Codable, Equatable, Hashable, IssuePullRequestData {
    public var assignee: User?
    public var assignees: [User]?
    public var base: PRBranchInfo?
    public var body: String?
    public var closedAt: Date?
    public var comments: Int64?
    public var createdAt: Date?
    public var diffUrl: String?
    public var dueDate: Date?
    public var head: PRBranchInfo?
    public var htmlUrl: String?
    public var _id: Int64?
    public var labels: [Label]?
    public var mergeBase: String?
    public var mergeCommitSha: String?
    public var mergeable: Bool?
    public var merged: Bool?
    public var mergedAt: Date?
    public var mergedBy: User?
    public var milestone: Milestone?
    public var number: Int64?
    public var patchUrl: String?
    public var state: StateType?
    public var title: String?
    public var updatedAt: Date?
    public var url: String?
    public var user: User?

    public init(assignee: User?, assignees: [User]?, base: PRBranchInfo?, body: String?, closedAt: Date?, comments: Int64?, createdAt: Date?, diffUrl: String?, dueDate: Date?, head: PRBranchInfo?, htmlUrl: String?, _id: Int64?, labels: [Label]?, mergeBase: String?, mergeCommitSha: String?, mergeable: Bool?, merged: Bool?, mergedAt: Date?, mergedBy: User?, milestone: Milestone?, number: Int64?, patchUrl: String?, state: StateType?, title: String?, updatedAt: Date?, url: String?, user: User?) {
        self.assignee = assignee
        self.assignees = assignees
        self.base = base
        self.body = body
        self.closedAt = closedAt
        self.comments = comments
        self.createdAt = createdAt
        self.diffUrl = diffUrl
        self.dueDate = dueDate
        self.head = head
        self.htmlUrl = htmlUrl
        self._id = _id
        self.labels = labels
        self.mergeBase = mergeBase
        self.mergeCommitSha = mergeCommitSha
        self.mergeable = mergeable
        self.merged = merged
        self.mergedAt = mergedAt
        self.mergedBy = mergedBy
        self.milestone = milestone
        self.number = number
        self.patchUrl = patchUrl
        self.state = state
        self.title = title
        self.updatedAt = updatedAt
        self.url = url
        self.user = user
    }

    public enum CodingKeys: String, CodingKey {
        case assignee
        case assignees
        case base
        case body
        case closedAt = "closed_at"
        case comments
        case createdAt = "created_at"
        case diffUrl = "diff_url"
        case dueDate = "due_date"
        case head
        case htmlUrl = "html_url"
        case _id = "id"
        case labels
        case mergeBase = "merge_base"
        case mergeCommitSha = "merge_commit_sha"
        case mergeable
        case merged
        case mergedAt = "merged_at"
        case mergedBy = "merged_by"
        case milestone
        case number
        case patchUrl = "patch_url"
        case state
        case title
        case updatedAt = "updated_at"
        case url
        case user
    }
}
