//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct PayloadCommit: Codable {
    
    public var added: [String]?
    public var author: PayloadUser?
    public var committer: PayloadUser?
    public var _id: String?
    public var message: String?
    public var modified: [String]?
    public var removed: [String]?
    public var timestamp: Date?
    public var url: String?
    public var verification: PayloadCommitVerification?
    
    public init(added: [String]?, author: PayloadUser?, committer: PayloadUser?, _id: String?, message: String?, modified: [String]?, removed: [String]?, timestamp: Date?, url: String?, verification: PayloadCommitVerification?) { 
        self.added = added
        self.author = author
        self.committer = committer
        self._id = _id
        self.message = message
        self.modified = modified
        self.removed = removed
        self.timestamp = timestamp
        self.url = url
        self.verification = verification
    }
    
    public enum CodingKeys: String, CodingKey { 
        case added
        case author
        case committer
        case _id = "id"
        case message
        case modified
        case removed
        case timestamp
        case url
        case verification
    }
}
