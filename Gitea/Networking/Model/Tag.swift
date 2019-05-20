//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Tag: Codable {
    
    public var commit: Commit?
    public var name: String?
    public var tarballUrl: String?
    public var zipballUrl: String?
    
    public init(commit: Commit?, name: String?, tarballUrl: String?, zipballUrl: String?) {
        self.commit = commit
        self.name = name
        self.tarballUrl = tarballUrl
        self.zipballUrl = zipballUrl
    }
    
    public enum CodingKeys: String, CodingKey { 
        case commit
        case name
        case tarballUrl = "tarball_url"
        case zipballUrl = "zipball_url"
    }
}
