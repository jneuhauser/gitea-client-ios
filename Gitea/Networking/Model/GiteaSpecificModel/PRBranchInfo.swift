//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct PRBranchInfo: Codable, Equatable, Hashable {
    public var label: String?
    public var ref: String?
    public var repo: Repository?
    public var repoId: Int64?
    public var sha: String?

    public init(label: String?, ref: String?, repo: Repository?, repoId: Int64?, sha: String?) {
        self.label = label
        self.ref = ref
        self.repo = repo
        self.repoId = repoId
        self.sha = sha
    }

    public enum CodingKeys: String, CodingKey {
        case label
        case ref
        case repo
        case repoId = "repo_id"
        case sha
    }
}
