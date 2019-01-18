//
//  Extension+UIView.swift
//  NewsFeed
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit.UIView

extension UIView: NibLoadable {
    
    static var nib: UINib {
        get {
            return UINib(nibName: name, bundle: bundle)
        }
    }
}
