//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Commit: Codable, Equatable, Hashable {
    
    public var author: User?
    public var commit: RepoCommit?
    public var committer: User?
    public var htmlUrl: String?
    public var parents: [CommitMeta]?
    public var sha: String?
    public var url: String?
    
    public init(author: User?, commit: RepoCommit?, committer: User?, htmlUrl: String?, parents: [CommitMeta]?, sha: String?, url: String?) { 
        self.author = author
        self.commit = commit
        self.committer = committer
        self.htmlUrl = htmlUrl
        self.parents = parents
        self.sha = sha
        self.url = url
    }
    
    public enum CodingKeys: String, CodingKey { 
        case author
        case commit
        case committer
        case htmlUrl = "html_url"
        case parents
        case sha
        case url
    }
}
