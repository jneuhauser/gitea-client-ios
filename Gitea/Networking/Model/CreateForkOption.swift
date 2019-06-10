//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateForkOption: Codable, Equatable, Hashable {
    
    public var organization: String?
    
    public init(organization: String?) { 
        self.organization = organization
    }
}
