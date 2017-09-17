//
//  ViewController.swift
//  Home Assistant
//
//  Created by Reza Moallemi on 9/14/17.
//  Copyright © 2017 Reza Moallemi. All rights reserved.
//

import Cocoa
import WebKit

class BrowserViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        webView.load(URLRequest(url: URL(string: PreferenceManager.sharedInstance.defaultAddress)!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.doubleValue = 0.0
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1.0
            progressView.doubleValue = webView.estimatedProgress
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showDialog(message: error.localizedDescription, info: "")
    }
    
    func showDialog(message: String, info: String) {
        let alert: NSAlert = NSAlert()
        alert.messageText = message
        alert.informativeText = info
        alert.alertStyle = NSAlertStyle.critical
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: view.window!, completionHandler: nil)
    }
    
}

