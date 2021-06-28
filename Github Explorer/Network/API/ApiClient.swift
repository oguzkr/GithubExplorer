//
//  ApiClient.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 24.06.2021.
//

import Foundation
import Alamofire
import SVProgressHUD

class networkManager {
    
    
    var searchResults = [GithubUsers]()
    var following =  [Following]()
    var userDetail : UserDetail?
    
    func BASE_API(with: String) -> String {
        return "https://api.github.com/\(with)"
    }
    
    func searchUser(userName: String, completed: @escaping (_ success: Bool) -> ()){
        SVProgressHUD.show()
        let parameters = ["q": "\(userName) in:login"]
        AF.request(BASE_API(with: "search/users"), method: .get, parameters: parameters).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completed(false)
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(GithubUsers.self, from: data)
                    self.searchResults = [result]
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        completed(true)
                    }
                } catch let error {
                    print(error)
                    completed(false)
                    SVProgressHUD.dismiss()
                }
            }
        }.resume()
    }
    
    func getUserDetail(userName: String, completed: @escaping (_ success: Bool) -> ()){
        SVProgressHUD.show()
        AF.request(BASE_API(with: "users/\(userName)"), method: .get).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completed(false)
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(UserDetail.self, from: data)
                    self.userDetail = result
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        completed(true)
                    }
                } catch let error {
                    completed(false)
                    print(error)
                    SVProgressHUD.dismiss()
                }
            }
        }.resume()
    }
    
    
    func followUser(accessToken: String, userName: String,completed: @escaping (_ success: Bool) -> ()){
        let headers : HTTPHeaders =
        [
            "Accept": "application/vnd.github.v3+json",
            "Content-Length": "0",
            "Content-Type": "application/vnd.github.v3+json",
            "Authorization" : "token \(accessToken)"
        ]
        AF.request(BASE_API(with: "user/following/\(userName)"), method: .put,headers: headers).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completed(false)
            case .success(let data):
                let outputStr  = String(data: data, encoding: String.Encoding.utf8) as String?
                print("data \(outputStr!)")
                DispatchQueue.main.async {
                    completed(true)
                }
            }
        }.resume()
    }
    
    
    func unFollowUser(accessToken: String, userName: String, completed: @escaping (_ success: Bool) -> ()){
        let headers : HTTPHeaders =
        [
            "Accept": "application/vnd.github.v3+json",
            "Content-Length": "0",
            "Content-Type": "application/vnd.github.v3+json",
            "Authorization" : "token \(accessToken)"
        ]
        AF.request(BASE_API(with: "user/following/\(userName)"), method: .delete,headers: headers).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completed(false)
            case .success(let data):
                let outputStr  = String(data: data, encoding: String.Encoding.utf8) as String?
                print("data \(outputStr!)")
                DispatchQueue.main.async {
                    completed(true)
                }
            }
        }.resume()
    }
    
    func getFollowingUsers(userName: String, completed: @escaping (_ success: Bool) -> ()){
        AF.request(BASE_API(with: "users/\(userName)/following"), method: .get).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completed(false)
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode([Following].self, from: data)
                    self.following = result
                    print(self.following)
                    DispatchQueue.main.async {
                        completed(true)
                    }
                } catch let error {
                    print(error)
                }
            }
        }.resume()
    }
  
}

//MARK: Authentication
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
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
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
        request.addValue("token " + accessToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            if error == nil {
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                let id: Int! = (result?["id"] as! Int)
                let displayName: String! = (result?["login"] as! String)
                let email: String? = (result?["email"] as? String)
                let avatarURL: String! = (result?["avatar_url"] as! String)
                let savedPerson = User(id: id, displayName: displayName, email: email!, avatarURL: avatarURL, token: accessToken)
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

