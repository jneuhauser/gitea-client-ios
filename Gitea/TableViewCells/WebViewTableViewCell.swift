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
    
}

extension WebViewTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height
            self.webViewResizeCallback?(webView.tag, self.webViewHeightConstraint.constant)
        }
    }
}
