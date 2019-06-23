//
//  PopUpControllerGenerator.swift
//  Gitea
//
//  Created by Johann Neuhauser on 21.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation
import UIKit

typealias ActionHandler = (_: UIAlertAction) -> Void

class PopUpControllerGenerator {
    static func createPopUp(withTitle title: String, andMessage message: String, noHandler: ActionHandler? = nil, yesHandler: ActionHandler? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Assume a dimissable pop up if no handlers are set
        if noHandler == nil && yesHandler == nil {
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(dismissAction)
        } else {
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: noHandler)
            alertController.addAction(noAction)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
            alertController.addAction(yesAction)
        }
        
        return alertController
    }
}
