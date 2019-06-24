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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openInExtenalBrowser(_:)))

        view = webView
    }

    public func load(_ url: URL) {
        let request = URLRequest(url: url)
        load(request)
    }

    public func load(_ request: URLRequest) {
        if title == nil {
            title = request.url?.absoluteString
        }
        webView.load(request)
    }

    @objc private func openInExtenalBrowser(_: UIBarButtonItem) {
        if let url = webView.url {
            let question = "Open \(url.absoluteString) in external browser?"
            let popUp = PopUpControllerGenerator.createPopUp(withTitle: "External Browser", andMessage: question) { _ in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            navigationController?.present(popUp, animated: true, completion: nil)
        }
    }
}
