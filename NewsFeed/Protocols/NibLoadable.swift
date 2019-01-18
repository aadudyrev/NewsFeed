//
//  NibLoadable.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

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



