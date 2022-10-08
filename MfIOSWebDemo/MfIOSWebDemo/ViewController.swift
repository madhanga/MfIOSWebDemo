//
//  ViewController.swift
//  MfIOSWebDemo
//
//  Created by Rajesh Deshmukh on 08/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    var seletedUserType: UserType = .bunty
    var seletedEnvionmentType: EnvionmentType = .uat
    var radioBtnSeleted: EnvionmentType = .uat
    
    @IBOutlet weak var tf_token: UITextView!
    @IBOutlet weak var imgUAT: UIImageView!
    @IBOutlet weak var imgCUG: UIImageView!
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tf_token.delegate = self
        setPlaceholderLabel()
        setRadioBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //Bunty
    @IBAction func btnBuntyUATClicked(_ sender: Any) {
        seletedEnvionmentType = .uat
        seletedUserType = .bunty
        openWKWebView()
    }
    
    @IBAction func btnBuntyCUGClicked(_ sender: Any) {
        seletedEnvionmentType = .cug
        seletedUserType = .bunty
        openWKWebView()
    }
    
    //Madhan
    @IBAction func btnMadhanUATClicked(_ sender: Any) {
        seletedEnvionmentType = .uat
        seletedUserType = .madhan
        openWKWebView()
    }
    
    @IBAction func btnMadhanCUGClicked(_ sender: Any) {
        seletedEnvionmentType = .cug
        seletedUserType = .madhan
        openWKWebView()
    }
    
    @IBAction func btnGoClicked(_ sender: Any) {
        seletedUserType = .other
        if tf_token.text == "" {
            showAlert()
        } else {
            openWKWebView()
        }
    }
    
    @IBAction func btnOtherUATClicked(_ sender: Any) {
        seletedEnvionmentType = .uat
        radioBtnSeleted = .uat
        seletedUserType = .other
        setRadioBtn()
    }
    
    @IBAction func btnOtherCUGClicked(_ sender: Any) {
        seletedEnvionmentType = .cug
        radioBtnSeleted = .cug
        seletedUserType = .other
        setRadioBtn()
    }
    
    func openWKWebView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: WebViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.urlStr = getURLStr()
        viewController.tokenStr = getTokenStr()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getURLStr() -> String {
        var urlStr: String
        urlStr = (seletedEnvionmentType == .uat) ? AppURLConstant.uatURL : AppURLConstant.cugURL
        print("URL: \(urlStr)")
        return urlStr
    }
    
    func getTokenStr() -> String {
        
        var token: String = ""
        if seletedUserType == .bunty {
            token =  (seletedEnvionmentType == .uat) ? AppTokenConstant.uatBuntyToken : AppTokenConstant.cugBuntyToken
        } else if seletedUserType == .madhan {
            token =  (seletedEnvionmentType == .uat) ? AppTokenConstant.uatMadhanToken : AppTokenConstant.cugMadhanToken
        } else if seletedUserType == .other {
            token =  tf_token.text ?? ""
        }
        print("token: \(token)")
        return token
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Please enter token.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setPlaceholderLabel() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "enter token"
        placeholderLabel.font = .italicSystemFont(ofSize: (tf_token.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        tf_token.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tf_token.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !tf_token.text.isEmpty
    }
    
    func setRadioBtn() {
        imgUAT.image = (radioBtnSeleted == .uat) ?  UIImage(named: "checked") : UIImage(named: "unchecked")
        imgCUG.image = (radioBtnSeleted == .cug) ?  UIImage(named: "checked") : UIImage(named: "unchecked")
    }
    
}

extension ViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

struct AppURLConstant {
//    static let uatURL = "https://uat.angelone.in/mutual-funds/discoverfunds"
//    static let cugURL = "https://cug.angelone.in/mutual-funds/discoverfunds"
     static let uatURL = "https://web-mf-uat.angelbroking.com/mutual-funds/discoverfunds"
     static let cugURL = "https://web-mf-cug.angelbroking.com/mutual-funds/discoverfunds"
}

struct AppTokenConstant {
    
    static let uatBuntyToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTY1NjUwNjAsInVzZXJEYXRhIjp7InVzZXJfaWQiOiJCNTM1ODYifX0.aFfuu4P9H6spjCQjDGCCnF2WC7lx7A8wu4fPQ1i8bXs"
    
    static let cugBuntyToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTY1NjQ5MzAsInVzZXJEYXRhIjp7InVzZXJfaWQiOiJCNTM1ODYifX0._HEOXY3IqDEreiLOvDS2hJTQQMr5o9l8ZPKXuYyK-44"
    
    static let uatMadhanToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTY3NTE5MzcsInVzZXJEYXRhIjp7InVzZXJfaWQiOiJCNTM1ODYifX0.I-96qq5_2E2cPbwjR6Foc6EDUDMiXUJKIc_EKuVVcuY"
    
    static let cugMadhanToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTY3NTE5NDksInVzZXJEYXRhIjp7InVzZXJfaWQiOiJCNTM1ODYifX0.AHb3Vx7bVp1PyW3CuWS-ty_Cb0OqavQU_UjdFRyexao"
}


enum UserType {
    case bunty, madhan, other
}

enum EnvionmentType {
    case uat, cug
}
