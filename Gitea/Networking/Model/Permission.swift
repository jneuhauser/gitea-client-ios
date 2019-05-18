//
//  Permission.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct Permission : Codable {

        let admin : Bool?
        let pull : Bool?
        let push : Bool?

        enum CodingKeys: String, CodingKey {
                case admin = "admin"
                case pull = "pull"
                case push = "push"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                admin = try values.decodeIfPresent(Bool.self, forKey: .admin)
                pull = try values.decodeIfPresent(Bool.self, forKey: .pull)
                push = try values.decodeIfPresent(Bool.self, forKey: .push)
        }

}
