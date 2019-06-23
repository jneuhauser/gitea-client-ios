//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct GitEntry: Codable, Equatable, Hashable {
    public var mode: String?
    public var path: String?
    public var sha: String?
    public var size: Int64?
    public var type: String?
    public var url: String?

    public init(mode: String?, path: String?, sha: String?, size: Int64?, type: String?, url: String?) {
        self.mode = mode
        self.path = path
        self.sha = sha
        self.size = size
        self.type = type
        self.url = url
    }
}
