//
//  Extension+UIViewController.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

protocol NibLoadable: class {
    
}

extension NibLoadable {
    
    static var name: String {
        get {
            return String(describing: self)
        }
    }
    
    static var bundle: Bundle {
        get {
            return Bundle(for: self)
        }
    }
}

extension UIViewController: NibLoadable {
    
    static func loadFromNib() -> Self {
        let vc = self.init(nibName: name, bundle: bundle)
        return vc
    }
}

extension UIView: NibLoadable {
    
    static var nib: UINib {
        get {
            return UINib(nibName: name, bundle: bundle)
        }
    }
}

extension UIView {
    func dropShadow(shadowColor: UIColor = UIColor.black,
                    fillColor: UIColor = UIColor.black,
                    opacity: Float = 1,
                    offset: CGSize = CGSize(width: 0, height: 0),
                    radius: CGFloat = 10) -> CAShapeLayer {
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        layer.insertSublayer(shadowLayer, at: 0)
        
        return shadowLayer
    }
}
