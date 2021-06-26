//
//  userDetail.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 25.06.2021.
//

import UIKit

protocol UserDetailDelegate {
    func followUser()
    func unFollowUser()
}

class userDetail: UIView {
    
    var userInfo : UserDetail?
    var delegate:UserDetailDelegate?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageViewProfile: RoundedImageView!
    @IBOutlet weak var buttonFollow: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    
    var following = Bool()

    @IBAction func clickedClose(_ sender: Any) {
        closePopUp()
    }
    
    
    @IBAction func clickedFollow(_ sender: Any) {
        if following {
            self.delegate?.unFollowUser()
            self.buttonFollow.setTitle("Follow", for: .normal)
            following = false
        } else {
            self.delegate?.followUser()
            self.buttonFollow.setTitle("Unfollow", for: .normal)
            following = true
        }
    }
 
    
    func closePopUp(){
        UIView.animate(withDuration: 0.5, animations: {
                self.frame.origin.y += 1000
                self.alpha = 0
            }, completion: { finished in
                self.removeFromSuperview()
            })
    }
    
}
