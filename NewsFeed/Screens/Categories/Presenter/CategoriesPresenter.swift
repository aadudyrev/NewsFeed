//
//  CategoriesPresenter.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class CategoriesPresenter {
    
    private let output: CategoriesOutput    
    private let router = Router.shared
    private let categories: [CategoryModel]
    
    init(output: CategoriesOutput) {
        categories = [CategoryModel(category: .general, title: "Главные", imageName: "general"),
                      CategoryModel(category: .search, title: "Поиск", imageName: "search"),
                      CategoryModel(category: .health, title: "Здоровье", imageName: "health"),
                      CategoryModel(category: .business, title: "Бизнес", imageName: "business"),
                      CategoryModel(category: .sports, title: "Спорт", imageName: "sports"),
                      CategoryModel(category: .technology, title: "Технологии", imageName: "technology"),
                      CategoryModel(category: .science, title: "Наука", imageName: "science"),
                      CategoryModel(category: .saved, title: "Сохраненные", imageName: "")]
        
        self.output = output
    }
}

extension CategoriesPresenter: CategoriesInput {
    func selectItem(at indexPath: IndexPath) {
        router.showNewsFeed(with: categories[indexPath.row])
    }
    
    func getCategoriesList() -> [CategoryModel] {
        return categories
    }
}

