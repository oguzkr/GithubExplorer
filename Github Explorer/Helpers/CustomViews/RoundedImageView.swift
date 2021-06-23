//
//  RoundedImageView.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 23.06.2021.
//

import Foundation
import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    

    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            
            self.layer.borderWidth = borderWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor! {
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadow: Bool = false {
        didSet {
            
            if shadow {
                self.dropShadow()
            } else {
                self.layer.shadowOpacity = 0.0
            }
            //setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        
    }
    
    private func configure() {
        layer.masksToBounds = cornerRadius > 0
        clipsToBounds = true
    }
    
}
