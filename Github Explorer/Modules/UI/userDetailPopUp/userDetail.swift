//
//  userDetail.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 25.06.2021.
//

import UIKit

class userDetail: UIView {
    
    var userInfo : UserDetail?

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageViewProfile: RoundedImageView!
    @IBOutlet weak var buttonFollow: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    
  
    override func awakeFromNib() {
        labelName.text = userInfo?.name
    }

    @IBAction func clickedClose(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.origin.y += 1000
            self.alpha = 0
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }
    
    
    @IBAction func clickedFollow(_ sender: Any) {
        
    }
    
}
