//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct EditAttachmentOptions: Codable {
    
    public var name: String?
    
    public init(name: String?) { 
        self.name = name
    }
}
