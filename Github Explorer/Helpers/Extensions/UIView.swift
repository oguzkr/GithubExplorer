//
//  UIView.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 23.06.2021.
//

import Foundation
import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func dropShadow() {
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 5.0
        //layer.shouldRasterize = true
        layer.masksToBounds = false
    }
}


