//
//  CategoriesProtocols.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

protocol CategoriesInput {
    
    var title: String? { get }
    
    func getCategoriesList() -> [CategoryModel]
    func selectItem(at indexPath: IndexPath)
}

protocol CategoriesOutput: class {
    
}
