//
//  IntExtensions.swift
//  Gitea
//
//  Created by Johann Neuhauser on 11.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

extension Int64 {
    func getByteRepresentaion() -> String {
        let bytes = self
        if bytes < 1024 {
            return "\(bytes) B"
        } else if bytes < (1024 * 1024) {
            return "\(bytes / 1024) KB"
        } else if bytes < (1024 * 1024 * 1024) {
            return "\(bytes / ( 1024 * 1024)) MB"
        } else if bytes < (1024 * 1024 * 1024 * 1024) {
            return "\(bytes / ( 1024 * 1024 * 1024)) GB"
        } else {
            return "\(bytes / ( 1024 * 1024 * 1024 * 1024)) TB"
        }
    }
}
