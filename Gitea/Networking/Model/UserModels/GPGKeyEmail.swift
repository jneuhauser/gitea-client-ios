//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct GPGKeyEmail: Codable, Equatable, Hashable {
    public var email: String?
    public var verified: Bool?

    public init(email: String?, verified: Bool?) {
        self.email = email
        self.verified = verified
    }
}
