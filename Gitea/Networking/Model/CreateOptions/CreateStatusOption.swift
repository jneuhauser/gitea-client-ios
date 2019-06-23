//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateStatusOption: Codable, Equatable, Hashable {
    public var context: String?
    public var _description: String?
    public var state: StatusState?
    public var targetUrl: String?

    public init(context: String?, _description: String?, state: StatusState?, targetUrl: String?) {
        self.context = context
        self._description = _description
        self.state = state
        self.targetUrl = targetUrl
    }

    public enum CodingKeys: String, CodingKey {
        case context
        case _description = "description"
        case state
        case targetUrl = "target_url"
    }
}
