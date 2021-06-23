//
//  LocalizableUIButton.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 23.06.2021.
//

import Foundation
import UIKit

@IBDesignable
class LocalizableUIButton: UIButton {
    @IBInspectable var localizableTitle: String = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

}

@IBDesignable
class CustomizableButton: LocalizableUIButton {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
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
    
    @IBInspectable var title: String! {
        didSet {
            
            self.titleLabel?.text = title
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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        
    }
    
    private func configure() {
        layer.masksToBounds = cornerRadius > 0
        clipsToBounds = true
    }
    
}
