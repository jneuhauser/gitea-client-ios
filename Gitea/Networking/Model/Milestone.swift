//
//  Milestone.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct Milestone : Codable {

        let closedAt : String?
        let closedIssues : Int?
        let descriptionField : String?
        let dueOn : String?
        let id : Int?
        let openIssues : Int?
        let state : String?
        let title : String?

        enum CodingKeys: String, CodingKey {
                case closedAt = "closed_at"
                case closedIssues = "closed_issues"
                case descriptionField = "description"
                case dueOn = "due_on"
                case id = "id"
                case openIssues = "open_issues"
                case state = "state"
                case title = "title"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                closedAt = try values.decodeIfPresent(String.self, forKey: .closedAt)
                closedIssues = try values.decodeIfPresent(Int.self, forKey: .closedIssues)
                descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
                dueOn = try values.decodeIfPresent(String.self, forKey: .dueOn)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                openIssues = try values.decodeIfPresent(Int.self, forKey: .openIssues)
                state = try values.decodeIfPresent(String.self, forKey: .state)
                title = try values.decodeIfPresent(String.self, forKey: .title)
        }

}
