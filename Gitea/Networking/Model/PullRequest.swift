//
//  PullRequest.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct PullRequest : Codable {

        let merged : Bool?
        let mergedAt : String?

        enum CodingKeys: String, CodingKey {
                case merged = "merged"
                case mergedAt = "merged_at"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                merged = try values.decodeIfPresent(Bool.self, forKey: .merged)
                mergedAt = try values.decodeIfPresent(String.self, forKey: .mergedAt)
        }

}
