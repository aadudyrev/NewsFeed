//
//  GradientView.swift
//  NewsFeed
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    let startColor = UIColor(hex: 0xEDF5FF)
    let endColor = UIColor(hex: 0xB5BBBD)
    
    func cgColors() -> [CGColor] {
        return [startColor.cgColor, endColor.cgColor]
    }
}

class GradientView: UIView {

    private let constants = Constants()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = constants.cgColors()
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }

}
