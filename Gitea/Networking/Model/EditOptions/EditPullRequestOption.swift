//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct EditPullRequestOption: Codable, Equatable, Hashable {
    public var assignee: String?
    public var assignees: [String]?
    public var body: String?
    public var dueDate: Date?
    public var labels: [Int64]?
    public var milestone: Int64?
    public var state: String?
    public var title: String?

    public init(assignee: String?, assignees: [String]?, body: String?, dueDate: Date?, labels: [Int64]?, milestone: Int64?, state: String?, title: String?) {
        self.assignee = assignee
        self.assignees = assignees
        self.body = body
        self.dueDate = dueDate
        self.labels = labels
        self.milestone = milestone
        self.state = state
        self.title = title
    }

    public enum CodingKeys: String, CodingKey {
        case assignee
        case assignees
        case body
        case dueDate = "due_date"
        case labels
        case milestone
        case state
        case title
    }
}
