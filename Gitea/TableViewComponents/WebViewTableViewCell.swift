//
//  WebViewTableViewCell.swift
//  Gitea
//
//  Created by Johann Neuhauser on 31.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit
import WebKit

class WebViewTableViewCell: UITableViewCell {
    
    public static let reuseIdentifier: String = String(describing: self)
    public static let uiNib: UINib = UINib(nibName: "WebViewTableViewCell", bundle: nil)
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    
    public var webViewResizeCallback: ((_ tag: Int, _ height: CGFloat) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        webView.navigationDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            debugPrint("contentSize obseverd")
            if let scrollView = object as? UIScrollView {
                scrollView.removeObserver(self, forKeyPath: "contentSize")
                debugPrint(scrollView)
                if webViewHeightConstraint.constant != scrollView.contentSize.height {
                    webViewHeightConstraint.constant = scrollView.contentSize.height
                    webViewResizeCallback?(webView.tag, webViewHeightConstraint.constant)
                }
            }
        }
    }
    
}

extension WebViewTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        // This was only a workaround because of call to webView(didFinish) before it´s really finished
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
//            self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height
//            self.webViewResizeCallback?(webView.tag, self.webViewHeightConstraint.constant)
//        }
    }
}
