//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateGPGKeyOption: Codable, Equatable, Hashable {
    
    public var armoredPublicKey: String
    
    public init(armoredPublicKey: String) { 
        self.armoredPublicKey = armoredPublicKey
    }
    
    public enum CodingKeys: String, CodingKey { 
        case armoredPublicKey = "armored_public_key"
    }
}
