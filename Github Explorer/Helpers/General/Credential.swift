//
//  Credential.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 24.06.2021.
//

import Foundation

struct Credential {
    static let CLIENT_ID = "85a06088ff1e98509316"
    static let CLIENT_SECRET = "2ebc0128f4534d0e27b1febb06141c0382ab93e1"
    static let REDIRECT_URI = "https://divingfirebase.firebaseapp.com/__/auth/handler"
    static let SCOPE = "read:user,user:email,user:follow"
    static let TOKENURL = "https://github.com/login/oauth/access_token"
}
