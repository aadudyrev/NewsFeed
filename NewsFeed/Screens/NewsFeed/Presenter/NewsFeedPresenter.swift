//
//  NewsFeedPresenter.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class NewsFeedPresenter {
    
    private let router = Router.shared
    private let output: NewsFeedOutput
    private let category: CategoryModel
    private let networkManager = NetworkManager()    
    private var newsList: [News]?
    
    init(output: NewsFeedOutput, category: CategoryModel) {
        self.output = output
        self.category = category
    }
    
}

extension NewsFeedPresenter: NewsFeedInput {
    
    func getNews() -> [News]? {
        return newsList
    }
    
    func getStarted() {
        if category.category == .search {
            output.showSearchBar()
        }
        
        update()
    }
    
    func update() {
        output.startRefresh()
        
        networkManager.getNews(for: category.category) { [weak self] (articles, error) in
            
            self?.output.endRefresh()
            
            if let newsError = error {
                self?.output.showAlert(with: newsError.status, message: newsError.message)
                return
            }
            
            if let newArticles = articles {
                self?.newsList = newArticles.articles
                self?.output.reloadData()
            }
        }
    }
    
    func selectItem(at indexPath: IndexPath) {
        if let news = newsList?[indexPath.row] {
            router.showDetail(news: news)
        }
    }
}
