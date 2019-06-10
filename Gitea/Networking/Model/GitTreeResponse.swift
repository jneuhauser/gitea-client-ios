//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct GitTreeResponse: Codable, Equatable, Hashable {
    
    public var page: Int64?
    public var sha: String?
    public var totalCount: Int64?
    public var tree: [GitEntry]?
    public var truncated: Bool?
    public var url: String?
    
    public init(page: Int64?, sha: String?, totalCount: Int64?, tree: [GitEntry]?, truncated: Bool?, url: String?) { 
        self.page = page
        self.sha = sha
        self.totalCount = totalCount
        self.tree = tree
        self.truncated = truncated
        self.url = url
    }
    
    public enum CodingKeys: String, CodingKey { 
        case page
        case sha
        case totalCount = "total_count"
        case tree
        case truncated
        case url
    }
}
