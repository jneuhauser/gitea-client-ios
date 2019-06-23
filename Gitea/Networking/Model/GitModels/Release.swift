//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Release: Codable, Equatable, Hashable {
    public var assets: [Attachment]?
    public var author: User?
    public var body: String?
    public var createdAt: Date?
    public var draft: Bool?
    public var _id: Int64?
    public var name: String?
    public var prerelease: Bool?
    public var publishedAt: Date?
    public var tagName: String?
    public var tarballUrl: String?
    public var targetCommitish: String?
    public var url: String?
    public var zipballUrl: String?

    public init(assets: [Attachment]?, author: User?, body: String?, createdAt: Date?, draft: Bool?, _id: Int64?, name: String?, prerelease: Bool?, publishedAt: Date?, tagName: String?, tarballUrl: String?, targetCommitish: String?, url: String?, zipballUrl: String?) {
        self.assets = assets
        self.author = author
        self.body = body
        self.createdAt = createdAt
        self.draft = draft
        self._id = _id
        self.name = name
        self.prerelease = prerelease
        self.publishedAt = publishedAt
        self.tagName = tagName
        self.tarballUrl = tarballUrl
        self.targetCommitish = targetCommitish
        self.url = url
        self.zipballUrl = zipballUrl
    }

    public enum CodingKeys: String, CodingKey {
        case assets
        case author
        case body
        case createdAt = "created_at"
        case draft
        case _id = "id"
        case name
        case prerelease
        case publishedAt = "published_at"
        case tagName = "tag_name"
        case tarballUrl = "tarball_url"
        case targetCommitish = "target_commitish"
        case url
        case zipballUrl = "zipball_url"
    }
}
