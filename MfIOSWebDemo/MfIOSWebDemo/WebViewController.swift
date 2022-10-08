//
//  WebViewController.swift
//  CookiesDemo
//
//  Created by Rajesh Deshmukh on 15/09/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    
    //Added for multi-window in webview
    var customPopup: UIView?
    var popupWebView: WKWebView?
    var backbtn: UIButton?
    
    var urlStr: String?
    var tokenStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupWebView() {
       
        let userContentController = WKUserContentController()
        if let cookies = HTTPCookieStorage.shared.cookies {
            let script = getJSCookiesString(for: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(cookieScript)
        }
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
       
        guard let urlStr = urlStr else {
            return
        }
        
        var loadUrl: URL?
        loadUrl = URL(string: urlStr)
        guard let url = loadUrl else {
            return
        }
        
        var customRequest = URLRequest(url: url)
		customRequest.setValue(tokenStr, forHTTPHeaderField: "authtoken")
		customRequest.setValue("sparkiOS", forHTTPHeaderField: "platform")
		customRequest.httpShouldHandleCookies = true

		self.webView = WKWebView(frame: .zero)
		self.webView!.load(customRequest)
        
		webView.uiDelegate = self
		webView.navigationDelegate = self
        webView.configuration.preferences = preferences

		self.view.addSubview(self.webView)
        self.webView.frame = self.view.bounds
    }
    
    ///Generates script to create given cookies
    public func getJSCookiesString(for cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"

        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "'; "
        }
        return result
    }
    
    func createButton() -> UIButton {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "BackArrowTemplate"), for: .normal)
        backBtn.tintColor = .darkGray
        backBtn.addTarget(self, action: #selector(btnBackPressed(_:)), for: .touchUpInside)
        return backBtn
    }

    @objc private func btnBackPressed(_ sender: UIButton?) {
        
        backbtn?.removeFromSuperview()
        popupWebView?.removeFromSuperview()
        customPopup?.removeFromSuperview()
        
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        
        //Added below code for multi window webview
        //Popupview
        customPopup = UIView()
        customPopup?.frame = self.view.frame
        customPopup?.backgroundColor = .white
        
        //Back button
        backbtn = createButton()
        let backbtnWidth = 50.0
        let backbtnHeight = 30.0
        let backbtnXCord = 0.0
        let backbtnYCord = (statusBarHeight + ((navigationBarHeight/2)-(backbtnHeight/2)))
        backbtn?.frame = CGRect.init(x: backbtnXCord, y: backbtnYCord, width: backbtnWidth, height: backbtnHeight)
		
        //Popup WebView
        popupWebView = WKWebView(frame: CGRect.init(x: 0, y: topBarHeight, width: view.bounds.size.width, height: view.bounds.size.height - topBarHeight),
								 configuration: configuration)
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        
        customPopup?.addSubview(backbtn!)
        customPopup?.addSubview(popupWebView!)
        view.addSubview(customPopup!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
        backbtn = nil
        customPopup = nil
    }
}

extension WebViewController: WKNavigationDelegate {
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       // UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url?.absoluteString ?? "")
        if navigationAction.request.url?.scheme == "tez" {
            let urlStr = navigationAction.request.url?.absoluteString
            let url = URL.init(string: urlStr ?? "")
            UIApplication.shared.open(url!)
            decisionHandler(.cancel)
        } else if(navigationAction.request.url?.absoluteString.hasSuffix("mutual-funds/exit") == true) {
            self.navigationController?.popViewController(animated: true)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

extension UIViewController {
    
    var topBarHeight: CGFloat {
        var topBarH : CGFloat = 0
        topBarH = statusBarHeight + navigationBarHeight
        return topBarH
    }
    
    var statusBarHeight : CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    var navigationBarHeight : CGFloat {
        var navBarHeight: CGFloat = 0
        navBarHeight = navigationController?.navigationBar.frame.height ?? 0.00
        return navBarHeight
    }

}
