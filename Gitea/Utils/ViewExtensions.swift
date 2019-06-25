//
//  ViewExtensions.swift
//  Gitea
//
//  Created by Johann Neuhauser on 23.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    struct AssociatedKeys {
        static var vSpinner: UIView?
    }

    // Stored properties are not allowed, so work with object associated objects
    private var vSpinner: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.vSpinner) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.vSpinner, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showSpinner() {
        guard vSpinner == nil else {
            return
        }

        let spinnerView = UIView(frame: bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.addSubview(spinnerView)
        }

        vSpinner = spinnerView
    }

    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
