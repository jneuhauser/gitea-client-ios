//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct EditReleaseOption: Codable, Equatable, Hashable {
    public var body: String?
    public var draft: Bool?
    public var name: String?
    public var prerelease: Bool?
    public var tagName: String?
    public var targetCommitish: String?

    public init(body: String?, draft: Bool?, name: String?, prerelease: Bool?, tagName: String?, targetCommitish: String?) {
        self.body = body
        self.draft = draft
        self.name = name
        self.prerelease = prerelease
        self.tagName = tagName
        self.targetCommitish = targetCommitish
    }

    public enum CodingKeys: String, CodingKey {
        case body
        case draft
        case name
        case prerelease
        case tagName = "tag_name"
        case targetCommitish = "target_commitish"
    }
}
