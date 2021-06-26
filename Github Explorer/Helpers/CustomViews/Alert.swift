//
//  Alert.swift
//  ios-auth-github
//
//  Created by Zach Bazov on 21/06/2020.
//  Copyright © 2020 Zach Bazov. All rights reserved.
//

import UIKit

let ALERT_TITLE =
"""
"\(Bundle.main.object(forInfoDictionaryKey: "CFBundleName")!)" uygulaması üzerinden github.com hesabına giriş yap.
"""

let ALERT_MESSAGE = "Bu uygulama github.com adresinden giriş yapmak için izin istiyor."

class Alert: UIAlertController {
    
    enum Provider {
        case github
    }
    
    var target: UIViewController!
    
    var provider: Provider!
    
    static var shared = Alert()
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(target: UIViewController, provider: Provider) {
        self.init()
        self.provider = provider
        self.target = target
        mode(provider)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func mode(_ provider: Provider) {
        switch provider {
        case .github:
            Alert.shared = Alert(title: ALERT_TITLE, message: ALERT_MESSAGE, preferredStyle: .alert)
            
            let dontAllow = UIAlertAction(title: "İzin verme", style: .default) { _ in
                self.target.dismiss(animated: true, completion: nil)
            }
            
            let allow = UIAlertAction(title: "İzin ver", style: .default) { _ in
                (self.target as! ViewController).presentWebViewController(provider)
            }
            
            Alert.shared.addAction(dontAllow)
            Alert.shared.addAction(allow)
        }
        
    }
    
    func present() {
        target.present(Alert.shared, animated: true, completion: nil)
    }
}
