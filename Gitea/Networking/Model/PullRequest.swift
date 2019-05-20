//
//  PullRequest.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct PullRequest : Codable {

        let assignee : User?
        let assignees : [User]?
        let base : PRBranchInfo?
        let body : String?
        let closedAt : String?
        let comments : Int?
        let createdAt : String?
        let diffUrl : String?
        let dueDate : String?
        let head : PRBranchInfo?
        let htmlUrl : String?
        let id : Int?
        let labels : [Label]?
        let mergeBase : String?
        let mergeCommitSha : String?
        let mergeable : Bool?
        let merged : Bool?
        let mergedAt : String?
        let mergedBy : User?
        let milestone : Milestone?
        let number : Int?
        let patchUrl : String?
        let state : String?
        let title : String?
        let updatedAt : String?
        let url : String?
        let user : User?

        enum CodingKeys: String, CodingKey {
                case assignee = "assignee"
                case assignees = "assignees"
                case base = "base"
                case body = "body"
                case closedAt = "closed_at"
                case comments = "comments"
                case createdAt = "created_at"
                case diffUrl = "diff_url"
                case dueDate = "due_date"
                case head = "head"
                case htmlUrl = "html_url"
                case id = "id"
                case labels = "labels"
                case mergeBase = "merge_base"
                case mergeCommitSha = "merge_commit_sha"
                case mergeable = "mergeable"
                case merged = "merged"
                case mergedAt = "merged_at"
                case mergedBy = "merged_by"
                case milestone = "milestone"
                case number = "number"
                case patchUrl = "patch_url"
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
                base = try PRBranchInfo(from: decoder)
                body = try values.decodeIfPresent(String.self, forKey: .body)
                closedAt = try values.decodeIfPresent(String.self, forKey: .closedAt)
                comments = try values.decodeIfPresent(Int.self, forKey: .comments)
                createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
                diffUrl = try values.decodeIfPresent(String.self, forKey: .diffUrl)
                dueDate = try values.decodeIfPresent(String.self, forKey: .dueDate)
                head = try PRBranchInfo(from: decoder)
                htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                labels = try values.decodeIfPresent([Label].self, forKey: .labels)
                mergeBase = try values.decodeIfPresent(String.self, forKey: .mergeBase)
                mergeCommitSha = try values.decodeIfPresent(String.self, forKey: .mergeCommitSha)
                mergeable = try values.decodeIfPresent(Bool.self, forKey: .mergeable)
                merged = try values.decodeIfPresent(Bool.self, forKey: .merged)
                mergedAt = try values.decodeIfPresent(String.self, forKey: .mergedAt)
                mergedBy = try User(from: decoder)
                milestone = try Milestone(from: decoder)
                number = try values.decodeIfPresent(Int.self, forKey: .number)
                patchUrl = try values.decodeIfPresent(String.self, forKey: .patchUrl)
                state = try values.decodeIfPresent(String.self, forKey: .state)
                title = try values.decodeIfPresent(String.self, forKey: .title)
                updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
                url = try values.decodeIfPresent(String.self, forKey: .url)
                user = try User(from: decoder)
        }

}
