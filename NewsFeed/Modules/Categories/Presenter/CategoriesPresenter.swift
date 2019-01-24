//
//  CategoriesPresenter.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class CategoriesPresenter {
    
    private weak var output: CategoriesOutput?
    private let router = Router.shared
    private let categories: [CategoryModel]
    
    init(output: CategoriesOutput) {
        categories = [CategoryModel(category: .general, title: "General", imageName: "general"),
                      CategoryModel(category: .search, title: "Search", imageName: "search"),
                      CategoryModel(category: .health, title: "Health", imageName: "health"),
                      CategoryModel(category: .business, title: "Business", imageName: "business"),
                      CategoryModel(category: .sports, title: "Sports", imageName: "sports"),
                      CategoryModel(category: .technology, title: "Technology", imageName: "technology"),
                      CategoryModel(category: .science, title: "Science", imageName: "science"),
                      CategoryModel(category: .saved, title: "Saved", imageName: "saved")]
        
        self.output = output
    }
}

extension CategoriesPresenter: CategoriesInput {
    var title: String? {
        get {
            return "Categories"
        }
    }
    
    func selectItem(at indexPath: IndexPath) {
        router.showNewsFeed(with: categories[indexPath.row])
    }
    
    func getCategoriesList() -> [CategoryModel] {
        return categories
    }
}

