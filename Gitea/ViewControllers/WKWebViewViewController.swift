//
//  WKWebViewViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 23.06.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewViewController: UIViewController, WKNavigationDelegate {
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(openInExtenalBrowser(_:)))

        // We need a parent view to be able to draw the spinner
        view = UIView(frame: UIScreen.main.bounds)
        view.addSubview(webView)
        view.addConstraint(NSLayoutConstraint(item: view!, attribute: .top, relatedBy: .equal, toItem: webView, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view!, attribute: .bottom, relatedBy: .equal, toItem: webView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view!, attribute: .leading, relatedBy: .equal, toItem: webView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view!, attribute: .trailing, relatedBy: .equal, toItem: webView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
    }

    public func load(_ url: URL) {
        let request = URLRequest(url: url)
        load(request)
    }

    public func load(_ request: URLRequest) {
        if title == nil {
            title = request.url?.absoluteString
        }
        view.showSpinner()
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

    // MARK: WKNavigationDelegate

    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        view.removeSpinner()
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
        showToast(message: "Web request failed")
        view.removeSpinner()
    }

    func webView(_: WKWebView, didCommit _: WKNavigation!) {
        view.showSpinner()
    }
}
