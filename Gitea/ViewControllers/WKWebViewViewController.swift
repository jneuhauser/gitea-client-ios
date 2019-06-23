//
//  WKWebViewViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 23.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewViewController: UIViewController {

    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openInExtenalBrowser(_:)))
        
        self.view = webView
    }
    
    public func load(_ url: URL) {
        let request = URLRequest(url: url)
        self.title = url.absoluteString
        webView.load(request)
    }
    
    @objc private func openInExtenalBrowser(_ sender: UIBarButtonItem) {
        if let url = webView.url {
            let yes: ActionHandler = { _ in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            let question = "Open \(url.absoluteString) in external browser?"
            let popUp = PopUpControllerGenerator.createYesNoPopUp(withTitle: "External Browser", andMessage: question, yesHandler: yes, noHandler: nil)
            navigationController?.present(popUp, animated: true, completion: nil)
        }
    }
}
