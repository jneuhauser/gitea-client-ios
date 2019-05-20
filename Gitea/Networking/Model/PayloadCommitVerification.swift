//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct PayloadCommitVerification: Codable {
    
    public var payload: String?
    public var reason: String?
    public var signature: String?
    public var verified: Bool?
    
    public init(payload: String?, reason: String?, signature: String?, verified: Bool?) { 
        self.payload = payload
        self.reason = reason
        self.signature = signature
        self.verified = verified
    }
}
