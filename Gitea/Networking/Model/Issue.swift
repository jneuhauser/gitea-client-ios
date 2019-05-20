//
//  Issue.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//
// Example:
//    {
//        "assignee": {
//            "avatar_url": "string",
//            "email": "user@example.com",
//            "full_name": "string",
//            "id": 0,
//            "is_admin": true,
//            "language": "string",
//            "login": "string"
//        },
//        "assignees": [
//        {
//        "avatar_url": "string",
//        "email": "user@example.com",
//        "full_name": "string",
//        "id": 0,
//        "is_admin": true,
//        "language": "string",
//        "login": "string"
//        }
//        ],
//        "body": "string",
//        "closed_at": "2019-05-20T08:30:37.334Z",
//        "comments": 0,
//        "created_at": "2019-05-20T08:30:37.334Z",
//        "due_date": "2019-05-20T08:30:37.334Z",
//        "id": 0,
//        "labels": [
//        {
//        "color": "00aabb",
//        "id": 0,
//        "name": "string",
//        "url": "string"
//        }
//        ],
//        "milestone": {
//            "closed_at": "2019-05-20T08:30:37.334Z",
//            "closed_issues": 0,
//            "description": "string",
//            "due_on": "2019-05-20T08:30:37.334Z",
//            "id": 0,
//            "open_issues": 0,
//            "state": "string",
//            "title": "string"
//        },
//        "number": 0,
//        "pull_request": {
//            "merged": true,
//            "merged_at": "2019-05-20T08:30:37.334Z"
//        },
//        "state": "string",
//        "title": "string",
//        "updated_at": "2019-05-20T08:30:37.334Z",
//        "url": "string",
//        "user": {
//            "avatar_url": "string",
//            "email": "user@example.com",
//            "full_name": "string",
//            "id": 0,
//            "is_admin": true,
//            "language": "string",
//            "login": "string"
//        }
//    }

import Foundation

struct Issue : Codable {

        let assignee : User?
        let assignees : [User]?
        let body : String?
        let closedAt : String?
        let comments : Int?
        let createdAt : String?
        let dueDate : String?
        let id : Int?
        let labels : [Label]?
        let milestone : Milestone?
        let number : Int?
        let pullRequest : PullRequest?
        let state : String?
        let title : String?
        let updatedAt : String?
        let url : String?
        let user : User?

        enum CodingKeys: String, CodingKey {
                case assignee = "assignee"
                case assignees = "assignees"
                case body = "body"
                case closedAt = "closed_at"
                case comments = "comments"
                case createdAt = "created_at"
                case dueDate = "due_date"
                case id = "id"
                case labels = "labels"
                case milestone = "milestone"
                case number = "number"
                case pullRequest = "pull_request"
                case state = "state"
                case title = "title"
                case updatedAt = "updated_at"
                case url = "url"
                case user = "user"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                assignee = try User(from: decoder)
                assignees = try values.decodeIfPresent([User].self, forKey: .assignees)
                body = try values.decodeIfPresent(String.self, forKey: .body)
                closedAt = try values.decodeIfPresent(String.self, forKey: .closedAt)
                comments = try values.decodeIfPresent(Int.self, forKey: .comments)
                createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
                dueDate = try values.decodeIfPresent(String.self, forKey: .dueDate)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                labels = try values.decodeIfPresent([Label].self, forKey: .labels)
                milestone = try Milestone(from: decoder)
                number = try values.decodeIfPresent(Int.self, forKey: .number)
                pullRequest = try PullRequest(from: decoder)
                state = try values.decodeIfPresent(String.self, forKey: .state)
                title = try values.decodeIfPresent(String.self, forKey: .title)
                updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
                url = try values.decodeIfPresent(String.self, forKey: .url)
                user = try User(from: decoder)
        }

}
