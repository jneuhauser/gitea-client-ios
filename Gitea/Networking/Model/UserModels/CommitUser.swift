//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct CommitUser: Codable, Equatable, Hashable {
    
    public var date: String?
    public var email: String?
    public var name: String?
    
    public init(date: String?, email: String?, name: String?) { 
        self.date = date
        self.email = email
        self.name = name
    }
}
