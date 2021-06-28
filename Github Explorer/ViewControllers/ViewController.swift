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
        buttonSignIn.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if UserDefaults.standard.object(forKey: "SavedPerson") != nil {
            self.goToStoryBoard(storyboard: Storyboards.ProfileScreen)
        } else {
            UIView.animate(withDuration: 0.5) {
                self.buttonSignIn.alpha = 1
            }
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

