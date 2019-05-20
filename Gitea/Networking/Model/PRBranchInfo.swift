//
//  PRBranchInfo.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct PRBranchInfo : Codable {

        let label : String?
        let ref : String?
        let repo : Repo?
        let repoId : Int?
        let sha : String?

        enum CodingKeys: String, CodingKey {
                case label = "label"
                case ref = "ref"
                case repo = "repo"
                case repoId = "repo_id"
                case sha = "sha"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                label = try values.decodeIfPresent(String.self, forKey: .label)
                ref = try values.decodeIfPresent(String.self, forKey: .ref)
                repo = try Repo(from: decoder)
                repoId = try values.decodeIfPresent(Int.self, forKey: .repoId)
                sha = try values.decodeIfPresent(String.self, forKey: .sha)
        }

}
