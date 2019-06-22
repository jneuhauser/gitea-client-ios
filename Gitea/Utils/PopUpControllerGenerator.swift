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
    static func createYesNoPopUp(withTitle title: String, andMessage message: String, yesHandler: ActionHandler?, noHandler: ActionHandler?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: noHandler)
        alertController.addAction(noAction)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
        alertController.addAction(yesAction)
        
        return alertController
    }
}
