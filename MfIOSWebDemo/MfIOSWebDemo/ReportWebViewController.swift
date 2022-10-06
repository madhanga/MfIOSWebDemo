//
//  ReportWebViewController.swift
//  AngelSpark
//
//  Created by Esha Pancholi on 30/09/21.
//  Copyright © 2021 Angel One. All rights reserved.
//

import UIKit
import WebKit

internal final class ReportWebViewController: TransitionViewController {

	@IBOutlet private var webView: WKWebView!
	@IBOutlet private weak var screenTitleLabel: UILabel!
	@IBOutlet private weak var backButton: UIButton!
	public var ScreenTitle: String?
	public var webRequest: URLRequest?

	internal override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
        updateUIElements()
		loadWebRequest()
	}

	private func setupUI() {
		if let titleString = ScreenTitle {
			screenTitleLabel?.text = titleString
			screenTitleLabel?.isHidden = false
		}
    
		
		webView.scrollView.minimumZoomScale = 1.0
		webView.scrollView.maximumZoomScale = 1.0
		webView.scrollView.delegate = self
		let webscript: WKUserScript = getScriptForWebZoomPrevent()
		webView.configuration.userContentController.addUserScript(webscript)
		updateUIElements()
		
	}

	private func getScriptForWebZoomPrevent() -> WKUserScript {
		let source: String = "var meta = document.createElement('meta');" +
			"meta.name = 'viewport';" +
			"meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
			"var head = document.getElementsByTagName('head')[0];" +
			"head.appendChild(meta);"
		let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		return script
	}

	public func updateUIElements() {
		view.backgroundColor = UIColor.white
		webView.backgroundColor = UIColor.white
		screenTitleLabel!.textColor = UIColor.darkGray
        backButton!.tintColor = UIColor.darkGray
		
	}

	
	private func loadWebRequest() {
		webView.navigationDelegate = self
		webView.uiDelegate = self
		guard let req = webRequest else {
			return
		}
		webView.load(req)
		//UIInfoManager.sharedInstance.showActivityIndicator(parentView: self.view)
	}


	@IBAction func Backbuttonpressed(_ sender: Any) {
		//UIInfoManager.sharedInstance.hideActivityIndicator()
		if webView.canGoBack {
			webView.goBack()
		} else {
			navigationController?.popViewController(animated: true)
		}
	}

}

extension ReportWebViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return nil
	}
}

extension ReportWebViewController: WKNavigationDelegate, WKUIDelegate {

	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		//UIInfoManager.sharedInstance.hideActivityIndicator()
	}

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		//UIInfoManager.sharedInstance.hideActivityIndicator()
	}

	public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		/*UIInfoManager.sharedInstance.hideActivityIndicator()
		if error._domain == "NSURLErrorDomain" || error._domain == "WebKitErrorDomain" {
			Logger.log(of: .error, message: "NSURLDomain error on Report WebView: \(error.localizedDescription)")
		}
		if !ReachabilitySW.isConnectedToNetwork() {
			networkErrorHandlerView.isHidden = false
		}*/
	}

	public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		guard let serverTrust = challenge.protectionSpace.serverTrust else {
			completionHandler(.cancelAuthenticationChallenge, nil)
			return
		}
		let exceptions = SecTrustCopyExceptions(serverTrust)
		SecTrustSetExceptions(serverTrust, exceptions)
		completionHandler(.useCredential, URLCredential(trust: serverTrust))
	}

	public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		guard   navigationAction.targetFrame == nil, let url =  navigationAction.request.url else {
			return nil
		}
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		return nil
	}

}

