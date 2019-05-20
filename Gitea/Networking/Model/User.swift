//
//  User.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct User : Codable {

        let avatarUrl : String?
        let email : String?
        let fullName : String?
        let id : Int?
        let isAdmin : Bool?
        let language : String?
        let login : String?

        enum CodingKeys: String, CodingKey {
                case avatarUrl = "avatar_url"
                case email = "email"
                case fullName = "full_name"
                case id = "id"
                case isAdmin = "is_admin"
                case language = "language"
                case login = "login"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
                email = try values.decodeIfPresent(String.self, forKey: .email)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                isAdmin = try values.decodeIfPresent(Bool.self, forKey: .isAdmin)
                language = try values.decodeIfPresent(String.self, forKey: .language)
                login = try values.decodeIfPresent(String.self, forKey: .login)
        }

}
