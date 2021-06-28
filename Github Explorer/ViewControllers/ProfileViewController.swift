//
//  ProfileViewController.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 24.06.2021.
//

import UIKit
import SDWebImage
import SwiftGifOrigin
class ProfileViewController: UIViewController, UserDetailDelegate{
    
    //MARK: VARIABLES & OUTLETS
    var searchResults = [GithubUsers]()
    let defaults = UserDefaults.standard
    let network: networkManager = networkManager()
    @IBOutlet weak var imageViewProfile: RoundedImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var buttonLogout: CustomizableButton!
    @IBOutlet weak var buttonCancelSearch: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!

    //MARK: ATSTART
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfo()
        setTableView()
    }
    
    
    //MARK: CLICK EVENTS
    @IBAction func clickedLogout(_ sender: Any) {
        WebView.shared.deleteCookies()
        defaults.setValue(nil, forKey: "SavedPerson")
        self.goToStoryBoard(storyboard: Storyboards.LoginScreen)
        
    }
    
    @IBAction func clickedSearch(_ sender: Any) {
        self.view.endEditing(true)
        self.network.searchUser(userName: self.textFieldSearch.text!) { success in
            if success {
                self.searchResults = self.network.searchResults
                self.tableView.reloadData()
            } else {
                self.showAlert(titleInput: "Success", messageInput: "searching failed successfully")
            }
        }
    }
    
    @IBAction func clickCancelSearch(_ sender: Any) {
        textFieldSearch.text = ""
        searchResults.removeAll()
        tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.buttonCancelSearch.alpha = 0
            self.buttonSearch.alpha = 0
        }
    }


    //MARK: HELPER FUNCTIONS
    func showUserDetail(userName: String){
        network.getUserDetail(userName: userName) { success in
            if success {
                let headerView = Bundle.main.loadNibNamed("userDetail", owner:
                self, options: nil)?.first as? userDetail
                self.view.addSubview(headerView!)
                let centerOfView = CGRect(x:((self.view.frame.size.width / 2) - (headerView?.contentView.frame.width)! / 2), y: ((self.view.frame.size.height / 2) - (headerView?.contentView.frame.height)! / 2), width: (headerView?.contentView.frame.width)!, height: (headerView?.contentView.frame.height)!)
                
                headerView?.frame = centerOfView
                headerView?.alpha = 0
                headerView?.frame.origin.y += 1000
                
                UIView.animate(withDuration: 1) {
                    headerView?.frame.origin.y -= 1000
                    headerView?.alpha = 1
                }
                
                let url = URL(string: self.network.userDetail?.avatar_url ?? "")
                
                headerView?.labelName.text = "Name: \(self.network.userDetail?.name ?? "")"
                headerView?.labelUserName.text = "Username: \(self.network.userDetail?.login ?? "")"
                headerView?.labelFollowing.text = "Following: \(self.network.userDetail?.following ?? 0)"
                headerView?.labelFollowers.text = "Followers: \(self.network.userDetail?.followers ?? 0)"
                headerView?.imageViewProfile.sd_setImage(with: url, placeholderImage: UIImage.gif(asset: "load"))
                
                headerView?.delegate = self
                
                if self.network.userDetail?.login == self.labelName.text {
                    headerView?.buttonFollow.isHidden = true
                } else {
                    self.network.getFollowingUsers(userName: self.labelName.text!) { success in
                        if success {
                            headerView?.buttonFollow.setTitle("Follow", for: .normal)
                            headerView?.following = false
                            for userFollowing in self.network.following {
                                if self.network.userDetail?.login ?? "" == userFollowing.login {
                                    headerView?.buttonFollow.setTitle("Unfollow", for: .normal)
                                    headerView?.following = true
                                }
                            }
                        } else {
                            self.showAlert(titleInput: "error", messageInput: "something went wrong but we're working on it.")
                        }
                    }
                }
            } else {
                self.showAlert(titleInput: "HATA", messageInput: "Bir takım başarısızlıklar söz konusu. Sonra tekrar dene belki düzelir.")
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
    
    func setTableView(){
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "searchResultCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: PROTOCOL FUNCTIONS
    func followUser() {
        print("followuser")
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                self.network.followUser(accessToken: loadedPerson.token, userName: self.network.userDetail?.login ?? "") { success in
                    if success {
                        print("user followed \(self.network.userDetail?.login ?? "")")
                    } else {
                        self.showAlert(titleInput: "error", messageInput: "not able to follow \(self.network.userDetail?.login ?? "") right now :(")
                    }
                }
            }
        }
    }
    
    func unFollowUser() {        
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                self.network.unFollowUser(accessToken: loadedPerson.token, userName: self.network.userDetail?.login ?? "") { success in
                    if success {
                        print("user unfollowed \(self.network.userDetail?.login ?? "")")
                    } else {
                        self.showAlert(titleInput: "error", messageInput: "not able to unfollow \(self.network.userDetail?.login ?? "") right now :(")
                    }
                    
                }
            }
        }
    }
    
    
    //MARK: TEXTFIELD CUSTOMIZATIONS
    @IBAction func textFieldChanged(_ sender: Any) {
        if textFieldSearch.text!.count > 0 {
            UIView.animate(withDuration: 0.5) {
                self.buttonCancelSearch.alpha = 1
                self.buttonSearch.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.buttonCancelSearch.alpha = 0
                self.buttonSearch.alpha = 0
            }
        }
    }
    
    
    @IBAction func textFieldClickSearch(_ sender: Any) {
        self.view.endEditing(true)
        self.network.searchUser(userName: self.textFieldSearch.text!) { success in
            if success {
                self.searchResults = self.network.searchResults
                self.tableView.reloadData()
            } else {
                self.showAlert(titleInput: ":(", messageInput: "Searching failed successfully")
            }
            
        }
    }
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: TABLEVIEW CUSTOMIZATIONS
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
        
        let profilePic = URL(string: (searchResults.first?.items![indexPath.row].avatar_url)!)
        let nickName = searchResults.first?.items![indexPath.row].login
        
        cell.labelName.text = nickName
        cell.imageViewProfilePicture.sd_setImage(with: profilePic, placeholderImage: UIImage.gif(asset: "load"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let username = searchResults.first?.items![indexPath.row].login
        showUserDetail(userName: username!)
    }

}



