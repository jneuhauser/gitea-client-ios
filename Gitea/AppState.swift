//
//  AppState.swift
//  Gitea
//
//  Created by Johann Neuhauser on 06.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit
import Foundation

class AppState {
    
    // MARK: TabBarItem
    
    public enum TabBarItem: Int {
        case Repos = 0
        case Code
        case Issues
        case PullRequests
        case Releases
        case Invalid = 99
    }
    
    public static func getSelectedTabBarItem(fromIndex index: Int?) -> TabBarItem {
        if let index = index {
            return TabBarItem(rawValue: index) ?? .Invalid
        }
        return .Invalid
    }
    
    public static func disableOtherTabBarItems(ofTabBarController controller: UITabBarController?) {
        guard let controller = controller else {
            return
        }
        let currentItem = controller.tabBar.items?[controller.selectedIndex]
        var it = controller.tabBar.items?.makeIterator()
        while let item = it?.next() {
            if item != currentItem {
                item.isEnabled = false
            }
        }
    }
    
    public static func enableAllTabBarItems(ofTabBarController controller: UITabBarController?) {
        var it = controller?.tabBar.items?.makeIterator()
        while let item = it?.next() {
            item.isEnabled = true
        }
    }
    
    // MARK: Selected Repo
    
    public static var selectedRepo: Repository?
}
