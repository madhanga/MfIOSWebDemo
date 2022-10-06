//
//  WebViewController.swift
//  CookiesDemo
//
//  Created by Rajesh Deshmukh on 15/09/22.
//

import UIKit
import WebKit


class WebViewController: UIViewController {

    @IBOutlet private weak var screenTitleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private var webView: WKWebView!
    var popupWebView: WKWebView?
    public var ScreenTitle: String?
    var urlStr: String?
    var token: String?
    
    @IBOutlet weak var navHeaderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
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
       
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController
        webViewConfig.preferences = preferences
        
        print("urlStr = \(urlStr ?? "")")
        //print("token = \(token ?? "")")
        
        guard let urlStr = urlStr else {
            return
        }
        
        var loadUrl: URL?
        loadUrl = URL(string: urlStr)
        guard let url = loadUrl else {
            return
        }
        var customRequest = URLRequest(url: url)
        //customRequest.setValue(token, forHTTPHeaderField: "X-Token")
        //customRequest.setValue(token, forHTTPHeaderField: "X-authToken")
        customRequest.setValue(token, forHTTPHeaderField: "authtoken")
        customRequest.setValue("sparkiOS", forHTTPHeaderField: "platform")
       // customRequest.setValue("sparkiOS", forHTTPHeaderField: "X-platform")
//        customRequest.setValue(token, forHTTPHeaderField: "Authorization")
        customRequest.httpShouldHandleCookies = true
        self.webView = WKWebView(frame: .zero, configuration: webViewConfig)
        self.webView!.load(customRequest)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(self.webView)
    }
    
    func setupUI() {
        webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                webView.leftAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                webView.bottomAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                webView.rightAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
            ])
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
    
    @IBAction func Backbuttonpressed(_ sender: Any) {
        //UIInfoManager.sharedInstance.hideActivityIndicator()
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

extension WebViewController: WKUIDelegate {
    
    func webViewDidFinishLoad(webView: WKWebView){
        
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        view.addSubview(popupWebView!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
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
        } else if navigationAction.request.url?.absoluteString == "about:blank" {
            print("CLOSEEEEEEEEE")
            self.navigationController?.popViewController(animated: true)
            decisionHandler(.cancel)
        }else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
}


