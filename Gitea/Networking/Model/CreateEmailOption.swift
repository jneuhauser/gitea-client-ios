//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateEmailOption: Codable {
    
    public var emails: [String]?
    
    public init(emails: [String]?) { 
        self.emails = emails
    }
}
