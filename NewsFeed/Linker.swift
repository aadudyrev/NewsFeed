//
//  Linker.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class Linker {
    static let shared = Linker()
    
    private let localDataSource: LocalDataSourceLoader = CoreDataManager(completionClosure: {})
    
    private init() {
        
    }
    
    func createCategoriesViewController() -> CategoriesViewController {
        let categoriesVC = CategoriesViewController.loadFromNib()
        categoriesVC.presenter = CategoriesPresenter(output: categoriesVC)
        
        return categoriesVC
    }
    
    func createNewsFeedViewController(with category: CategoryModel) -> NewsFeedViewController {
        let networkManager = NetworkManager()
        let localDS = localDataSource
        let newsFeedVC = NewsFeedViewController.loadFromNib()
        let interactor = NewsFeedInteractor(remoteDataSource: networkManager, localDataSource: localDS)
        let presenter = NewsFeedPresenter(output: newsFeedVC, interactor: interactor, category: category)
        
        interactor.output = presenter
        newsFeedVC.presenter = presenter
        
        return newsFeedVC
    }
    
    func createNewsDetailViewController(with news: News) -> NewsDetailViewController {
        let newsDetailVC = NewsDetailViewController.loadFromNib()
        let presenter = NewsDetailPresenter(with: news, output: newsDetailVC)
        newsDetailVC.presenter = presenter
        
        return newsDetailVC
    }
}
