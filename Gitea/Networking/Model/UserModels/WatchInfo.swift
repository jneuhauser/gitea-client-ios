//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct WatchInfo: Codable, Equatable, Hashable {
    public var createdAt: Date?
    public var ignored: Bool?
    public var repositoryUrl: String?
    public var subscribed: Bool?
    public var url: String?

    public init(createdAt: Date?, ignored: Bool?, repositoryUrl: String?, subscribed: Bool?, url: String?) {
        self.createdAt = createdAt
        self.ignored = ignored
        self.repositoryUrl = repositoryUrl
        self.subscribed = subscribed
        self.url = url
    }

    public enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case ignored
        case repositoryUrl = "repository_url"
        case subscribed
        case url
    }
}
