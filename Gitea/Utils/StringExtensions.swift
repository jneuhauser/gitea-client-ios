//
//  StringExtensions.swift
//  Gitea
//
//  Created by Johann Neuhauser on 10.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

extension String {
    func getBase64() -> String {
        return data(using: .utf8)!.base64EncodedString()
    }
}
