//
//  ViewController.swift
//  CookiesDemo
//
//  Created by Rajesh Deshmukh on 14/09/22.
//

import UIKit

import SafariServices
class ViewController: UIViewController {

    var isNavBarHidden: Bool = false
    var safariViewController: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(isNavBarHidden ? true: false, animated: false)
    }
    
    func getURLStr(_ isUAT: Bool) -> String {
        var urlStr: String
        urlStr = isUAT ? "\(AppConstant.uatURL)?authToken=\(AppConstant.uatBuntyToken)" : "\(AppConstant.cugURL)?authToken=\(AppConstant.cugBuntyToken)"
        
        urlStr = isUAT ? "\(AppConstant.uatURL)" : "\(AppConstant.cugURL)"
        return urlStr
    }
    
    func getTokenStr(_ isUAT: Bool) -> String {
        var tokenStr: String
        tokenStr = isUAT ? AppConstant.uatBuntyToken : AppConstant.cugBuntyToken
        return tokenStr
    }
    
    @IBAction func btnWebViewUATWithCookiesUTapped(_ sender: Any) {
        isNavBarHidden = true
        openWebViewWithEnvironment(isUAT: true)
    }
    
    @IBAction func btnWebViewCugWithCookiesTapped(_ sender: Any) {
        isNavBarHidden = true
        openWebViewWithEnvironment(isUAT: false)
    }
    
    @IBAction func btnSafariViewControllerUatTapped(_ sender: Any) {
        isNavBarHidden = false
        openSafariWithEnvironment(isUAT: true)
    }
    
    @IBAction func btnSafariViewControllerCugTapped(_ sender: Any) {
        isNavBarHidden = false
        openSafariWithEnvironment(isUAT: false)
    }
    
    @IBAction func btnSparkWebViewUatTapped(_ sender: Any) {
        isNavBarHidden = true
        openSparkWebWebViewWithEnvironment(isUAT: true)
    }
    
    @IBAction func btnSparkWebViewCugTapped(_ sender: Any) {
        isNavBarHidden = true
        openSparkWebWebViewWithEnvironment(isUAT: false)
    }
    
}
extension ViewController {
    
    //Safari
    func openSafariWithEnvironment(isUAT: Bool) {
        let url = URL(string: getURLStr(isUAT))!
        safariViewController = SFSafariViewController(url: url)
        guard let safariViewController = safariViewController else {
            return
        }
        present(safariViewController, animated: false) {
            safariViewController.delegate = self
        }
    }
    
    //WKwebview
    func openWebViewWithEnvironment(isUAT: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: WebViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.urlStr = getURLStr(isUAT)
        viewController.token = getTokenStr(isUAT)
        viewController.ScreenTitle = "Mutual Fund"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //Spark - WKwebview
    func openSparkWebWebViewWithEnvironment(isUAT: Bool) {
        var loadUrl: URL?
        loadUrl = URL(string: getURLStr(isUAT))
        guard let url = loadUrl else {
            return
        }
        var customRequest = URLRequest(url: url)
        customRequest.setValue("someValue", forHTTPHeaderField: "customHeaderKey")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webVC: ReportWebViewController = storyboard.instantiateViewController(withIdentifier: "ReportWebViewController") as! ReportWebViewController
        webVC.webRequest = customRequest
        webVC.ScreenTitle = "Mutual Fund"
        navigationController?.pushViewController(webVC, animated: true)
    }
}

extension ViewController :SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

struct AppConstant {
    static let uatBuntyToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTY1NjUwNjAsInVzZXJEYXRhIjp7InVzZXJfaWQiOiJCNTM1ODYifX0.aFfuu4P9H6spjCQjDGCCnF2WC7lx7A8wu4fPQ1i8bXs"
    static let cugBuntyToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTY1NjQ5MzAsInVzZXJEYXRhIjp7InVzZXJfaWQiOiJCNTM1ODYifX0._HEOXY3IqDEreiLOvDS2hJTQQMr5o9l8ZPKXuYyK-44"
   // static let uatURL = "https://web-mf-uat.angelbroking.com/mutual-funds/discoverfunds"
    static let uatURL = "https://uat.angelone.in/mutual-funds/discoverfunds"
    static let cugURL = "https://web-mf-cug.angelbroking.com/mutual-funds/discoverfunds"
}
