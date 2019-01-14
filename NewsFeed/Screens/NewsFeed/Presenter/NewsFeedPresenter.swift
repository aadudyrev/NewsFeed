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
    private weak var output: NewsFeedOutput?
    private let category: CategoryModel
    private let networkManager = NetworkManager()    
    private var articles: Articles? {
        didSet {
            output?.reloadData()
        }
    }
    
    init(output: NewsFeedOutput, category: CategoryModel) {
        self.output = output
        self.category = category
    }
    
}

extension NewsFeedPresenter: NewsFeedInput {
    
    var newsList: [News] {
        get {
            return articles?.articles ?? [News]()
        }
    }
    
    var title: String? {
        get {
            return category.title
        }
    }
    
    var showSearchBar: Bool {
        get {
            return category.category == .search
        }
    }
    
    func getStarted() {
        update()
    }
    
    func update() {
        output?.startRefresh()
        
        let requestModel: NetworkRequestModel
        
        if category.category == .search {
            let searchText = output?.searchText
            requestModel = NetworkRequestModel.init(endPoint: .Everything, category: nil, searchText: searchText, country: nil)
        } else {
            requestModel = NetworkRequestModel.init(endPoint: .TopHeadlines, category: category.category, searchText: nil, country: nil)
        }
        
        networkManager.getNews(with: requestModel) { [weak self] (articles, error) in
            
            self?.output?.endRefresh()
            
            if let newsError = error {
                self?.output?.showAlert(with: newsError.status, message: newsError.message)
                return
            }
            
            if let newArticles = articles {
                self?.articles = newArticles
            }
        }
    }
    
    func selectItem(at indexPath: IndexPath) {
        if let news = articles?.articles?[indexPath.row] {
            router.showDetail(news: news)
        }
    }
}
