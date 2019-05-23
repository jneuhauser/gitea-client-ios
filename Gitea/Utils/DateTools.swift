//
//  DateTools.swift
//  Gitea
//
//  Created by Johann Neuhauser on 23.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation

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
