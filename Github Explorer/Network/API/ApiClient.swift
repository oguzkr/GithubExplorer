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
    
    func BASE_API(with: String) -> String {
        return "https://api.github.com/\(with)"
    }
    
    
    func searchUser(userName: String, completed: @escaping () -> ()){
        SVProgressHUD.show()
        let parameters = ["q": "\(userName) in:login"]
        AF.request(BASE_API(with: "search/users"), method: .get, parameters: parameters).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(GithubUsers.self, from: data)
                    self.searchResults = [result]
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        completed()
                    }
                } catch let error {
                    print(error)
                    SVProgressHUD.dismiss()
                }
            }
        }.resume()
    }
    
}
