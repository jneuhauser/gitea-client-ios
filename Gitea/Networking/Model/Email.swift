//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct Email: Codable {
    
    public var email: String?
    public var primary: Bool?
    public var verified: Bool?
    
    public init(email: String?, primary: Bool?, verified: Bool?) { 
        self.email = email
        self.primary = primary
        self.verified = verified
    }
}
