//
//  DateTools.swift
//  Gitea
//
//  Created by Johann Neuhauser on 23.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

// Accepts: "2019-05-13T10:08:07+02:00", "1996-12-19T16:39:57-08:00"
public let rfc3339DateFormatter: DateFormatter = {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    fmt.locale = Locale(identifier: "en_US_POSIX")
    return fmt
}()

private let dateComponentsFormatter: DateComponentsFormatter = {
    let fmt = DateComponentsFormatter()
    fmt.unitsStyle = .full
    fmt.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
    return fmt
}()

extension Date {
    public func getDifferenceToNow(withUnitCount unitCount: Int = 0) -> String? {
        let now = Date()
        let fmt = dateComponentsFormatter
        fmt.maximumUnitCount = unitCount
        return fmt.string(from: self, to: now)
    }
}
