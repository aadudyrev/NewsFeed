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

extension UIImageView {

}
