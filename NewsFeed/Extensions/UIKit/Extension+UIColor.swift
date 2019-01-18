//
//  Extension+UIColor.swift
//  NewsFeed
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit.UIColor

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}
