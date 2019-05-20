//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct RepoCommit: Codable {
    
    public var author: CommitUser?
    public var committer: CommitUser?
    public var message: String?
    public var tree: CommitMeta?
    public var url: String?
    
    public init(author: CommitUser?, committer: CommitUser?, message: String?, tree: CommitMeta?, url: String?) { 
        self.author = author
        self.committer = committer
        self.message = message
        self.tree = tree
        self.url = url
    }
}
