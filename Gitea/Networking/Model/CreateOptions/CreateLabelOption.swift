//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CreateLabelOption: Codable, Equatable, Hashable {
    
    public var color: String
    public var name: String
    
    public init(color: String, name: String) { 
        self.color = color
        self.name = name
    }
}
