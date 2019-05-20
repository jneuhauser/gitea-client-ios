//
//  Repo.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct Repo : Codable {

        let archived : Bool?
        let cloneUrl : String?
        let createdAt : String?
        let defaultBranch : String?
        let descriptionField : String?
        let empty : Bool?
        let fork : Bool?
        let forksCount : Int?
        let fullName : String?
        let htmlUrl : String?
        let id : Int?
        let mirror : Bool?
        let name : String?
        let openIssuesCount : Int?
        let owner : User?
        let permissions : Permission?
        let privateField : Bool?
        let size : Int?
        let sshUrl : String?
        let starsCount : Int?
        let updatedAt : String?
        let watchersCount : Int?
        let website : String?

        enum CodingKeys: String, CodingKey {
                case archived = "archived"
                case cloneUrl = "clone_url"
                case createdAt = "created_at"
                case defaultBranch = "default_branch"
                case descriptionField = "description"
                case empty = "empty"
                case fork = "fork"
                case forksCount = "forks_count"
                case fullName = "full_name"
                case htmlUrl = "html_url"
                case id = "id"
                case mirror = "mirror"
                case name = "name"
                case openIssuesCount = "open_issues_count"
                case owner = "owner"
                case permissions = "permissions"
                case privateField = "private"
                case size = "size"
                case sshUrl = "ssh_url"
                case starsCount = "stars_count"
                case updatedAt = "updated_at"
                case watchersCount = "watchers_count"
                case website = "website"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                archived = try values.decodeIfPresent(Bool.self, forKey: .archived)
                cloneUrl = try values.decodeIfPresent(String.self, forKey: .cloneUrl)
                createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
                defaultBranch = try values.decodeIfPresent(String.self, forKey: .defaultBranch)
                descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
                empty = try values.decodeIfPresent(Bool.self, forKey: .empty)
                fork = try values.decodeIfPresent(Bool.self, forKey: .fork)
                forksCount = try values.decodeIfPresent(Int.self, forKey: .forksCount)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                mirror = try values.decodeIfPresent(Bool.self, forKey: .mirror)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                openIssuesCount = try values.decodeIfPresent(Int.self, forKey: .openIssuesCount)
                owner = try User(from: decoder)
                permissions = try Permission(from: decoder)
                privateField = try values.decodeIfPresent(Bool.self, forKey: .privateField)
                size = try values.decodeIfPresent(Int.self, forKey: .size)
                sshUrl = try values.decodeIfPresent(String.self, forKey: .sshUrl)
                starsCount = try values.decodeIfPresent(Int.self, forKey: .starsCount)
                updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
                watchersCount = try values.decodeIfPresent(Int.self, forKey: .watchersCount)
                website = try values.decodeIfPresent(String.self, forKey: .website)
        }

}
