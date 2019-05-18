//
//  AccessToken.swift
//  Gitea Client
//
//  Created by Johann Neuhauser on 13.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

struct AccessToken : Codable {
        let id : Int
        let name : String
        let sha1 : String
}
