//
//  Label.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct Label : Codable {

        let color : String?
        let id : Int?
        let name : String?
        let url : String?

        enum CodingKeys: String, CodingKey {
                case color = "color"
                case id = "id"
                case name = "name"
                case url = "url"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                color = try values.decodeIfPresent(String.self, forKey: .color)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                url = try values.decodeIfPresent(String.self, forKey: .url)
        }

}
