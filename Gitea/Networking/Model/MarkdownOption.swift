//
//  Created by Johann Neuhauser on 16.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

public struct MarkdownOption: Codable {
    
    public var context: String?
    public var mode: String?
    public var text: String?
    public var wiki: Bool?
    
    public init(context: String?, mode: String?, text: String?, wiki: Bool?) { 
        self.context = context
        self.mode = mode
        self.text = text
        self.wiki = wiki
    }
    
    public enum CodingKeys: String, CodingKey { 
        case context = "Context"
        case mode = "Mode"
        case text = "Text"
        case wiki = "Wiki"
    }
}
