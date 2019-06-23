//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct EditOrgOption: Codable, Equatable, Hashable {
    public var _description: String?
    public var fullName: String?
    public var location: String?
    public var website: String?

    public init(_description: String?, fullName: String?, location: String?, website: String?) {
        self._description = _description
        self.fullName = fullName
        self.location = location
        self.website = website
    }

    public enum CodingKeys: String, CodingKey {
        case _description = "description"
        case fullName = "full_name"
        case location
        case website
    }
}
