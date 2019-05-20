//
// CreatePullRequestOption.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

/** CreatePullRequestOption options when creating a pull request */
public struct CreatePullRequestOption: Codable {


    public var assignee: String?

    public var assignees: [String]?

    public var base: String?

    public var body: String?

    public var dueDate: Date?

    public var head: String?

    public var labels: [Int64]?

    public var milestone: Int64?

    public var title: String?
    public init(assignee: String?, assignees: [String]?, base: String?, body: String?, dueDate: Date?, head: String?, labels: [Int64]?, milestone: Int64?, title: String?) { 
        self.assignee = assignee
        self.assignees = assignees
        self.base = base
        self.body = body
        self.dueDate = dueDate
        self.head = head
        self.labels = labels
        self.milestone = milestone
        self.title = title
    }
    public enum CodingKeys: String, CodingKey { 
        case assignee
        case assignees
        case base
        case body
        case dueDate = "due_date"
        case head
        case labels
        case milestone
        case title
    }

}
