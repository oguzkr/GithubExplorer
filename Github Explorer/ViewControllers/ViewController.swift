//
//  ViewController.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 23.06.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var buttonSignIn: CustomizableButton!
    
    //MARK: AT START
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if UserDefaults.standard.object(forKey: "SavedPerson") != nil {
            self.goToStoryBoard(storyboard: Storyboards.ProfileScreen)
        }
        
        
    }
    
    //MARK: CLICK ACTIONS
    @IBAction func clickedSignIn(_ sender: Any) {
        Alert(target: self, provider: .github).present()
    }
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshButtonTapped() {
        WebView.shared.reload()
    }
    
    //MARK: HELPER FUNCTIONS
    func presentWebViewController(_ provider: Alert.Provider) {
        WebView(target: self, provider: .github).mode(.github)
    }


    
}



//MARK: EXTENSIONS
extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.requestCallbackURL(request: navigationAction.request)
        decisionHandler(.allow)
    }
}

extension ViewController {
    
    func requestCallbackURL(request: URLRequest) {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(Credential.REDIRECT_URI) {
            if requestURLString.contains("code=") {
                if let range = requestURLString.range(of: "=") {
                    let code = requestURLString[range.upperBound...]
                    if let range = code.range(of: "&state=") {
                        let authCode = code[..<range.lowerBound]
                        requestAccessToken(authCode: String(authCode))
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func requestAccessToken(authCode: String) {
        let grantType = "authorization_code"
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + Credential.CLIENT_ID + "&client_secret=" + Credential.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: Credential.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, _) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                let accessToken = results?["access_token"] as? String
                self.requestUserProfile(accessToken: accessToken ?? "")
            }
        }
        task.resume()
    }
    
    func requestUserProfile(accessToken: String) {
        let tokenURL = "https://api.github.com/user"
        let verify: NSURL = NSURL(string: tokenURL)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            if error == nil {
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                let id: Int! = (result?["id"] as! Int)
                let displayName: String! = (result?["login"] as! String)
                let email: String? = (result?["email"] as? String)
                let avatarURL: String! = (result?["avatar_url"] as! String)
                
                let savedPerson = User(id: id, displayName: displayName, email: email!, avatarURL: avatarURL)
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(savedPerson) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "SavedPerson")
                }
                
                DispatchQueue.main.async {
                    self.goToStoryBoard(storyboard: Storyboards.ProfileScreen)
                }
            }
        }
        task.resume()
    }
}

