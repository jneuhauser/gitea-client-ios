//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct PayloadUser: Codable, Equatable, Hashable {
    public var email: String?
    public var name: String?
    public var username: String?

    public init(email: String?, name: String?, username: String?) {
        self.email = email
        self.name = name
        self.username = username
    }
}
