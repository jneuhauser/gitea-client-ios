//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Milestone: Codable, Equatable, Hashable {
    public var closedAt: Date?
    public var closedIssues: Int64?
    public var _description: String?
    public var dueOn: Date?
    public var _id: Int64?
    public var openIssues: Int64?
    public var state: StateType?
    public var title: String?

    public init(closedAt: Date?, closedIssues: Int64?, _description: String?, dueOn: Date?, _id: Int64?, openIssues: Int64?, state: StateType?, title: String?) {
        self.closedAt = closedAt
        self.closedIssues = closedIssues
        self._description = _description
        self.dueOn = dueOn
        self._id = _id
        self.openIssues = openIssues
        self.state = state
        self.title = title
    }

    public enum CodingKeys: String, CodingKey {
        case closedAt = "closed_at"
        case closedIssues = "closed_issues"
        case _description = "description"
        case dueOn = "due_on"
        case _id = "id"
        case openIssues = "open_issues"
        case state
        case title
    }
}
