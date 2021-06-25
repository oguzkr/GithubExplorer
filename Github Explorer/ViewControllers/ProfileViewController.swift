//
//  ProfileViewController.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 24.06.2021.
//

import UIKit
import SDWebImage
import SwiftGifOrigin
class ProfileViewController: UIViewController{

    

    @IBOutlet weak var imageViewProfile: RoundedImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var buttonLogout: CustomizableButton!
    @IBOutlet weak var buttonCancelSearch: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    let network: networkManager = networkManager()
    var searchResults = [GithubUsers]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfo()
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "searchResultCell")
        tableView.delegate = self
        tableView.dataSource = self

        
        
    }
    
    
    @IBAction func clickedLogout(_ sender: Any) {
        WebView.shared.deleteCookies()
        defaults.setValue(nil, forKey: "SavedPerson")
        self.goToStoryBoard(storyboard: Storyboards.LoginScreen)
        
    }
    
    @IBAction func clickCancelSearch(_ sender: Any) {
        textFieldSearch.text = ""
        UIView.animate(withDuration: 0.5) {
            self.buttonCancelSearch.alpha = 0
        }
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        if textFieldSearch.text! == "oguzkr" {
            UIView.animate(withDuration: 0.5) {
                self.buttonCancelSearch.alpha = 1
                
                self.network.searchUser(userName: self.textFieldSearch.text!) {
                    self.searchResults = self.network.searchResults
                    self.tableView.reloadData()
                }
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.buttonCancelSearch.alpha = 0
            }
        }
    }
    
  
    
    func setUserInfo(){
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                let url = URL(string: "\(loadedPerson.avatarURL)")
                imageViewProfile.sd_setImage(with: url, placeholderImage: UIImage.gif(asset: "load"))
                
                labelName.text = loadedPerson.displayName
                labelEmail.text = loadedPerson.email

            }
        }
    }
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 50
        let totalCount = searchResults.first?.items?.count
        if totalCount ?? 0 <= 50{
            count = totalCount ?? 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultTableViewCell
        cell.labelName.text = searchResults.first?.items![indexPath.row].login
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
