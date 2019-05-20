//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Attachment: Codable {
    
    public var browserDownloadUrl: String?
    public var createdAt: Date?
    public var downloadCount: Int64?
    public var _id: Int64?
    public var name: String?
    public var size: Int64?
    public var uuid: String?
    
    public init(browserDownloadUrl: String?, createdAt: Date?, downloadCount: Int64?, _id: Int64?, name: String?, size: Int64?, uuid: String?) { 
        self.browserDownloadUrl = browserDownloadUrl
        self.createdAt = createdAt
        self.downloadCount = downloadCount
        self._id = _id
        self.name = name
        self.size = size
        self.uuid = uuid
    }
    
    public enum CodingKeys: String, CodingKey { 
        case browserDownloadUrl = "browser_download_url"
        case createdAt = "created_at"
        case downloadCount = "download_count"
        case _id = "id"
        case name
        case size
        case uuid
    }
}
