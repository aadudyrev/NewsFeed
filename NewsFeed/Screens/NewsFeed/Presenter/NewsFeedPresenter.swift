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
    private let interactor: NewsFeedInteractorInput?
    private let categoryModel: CategoryModel
    private var news = [News]()
    
    init(output: NewsFeedOutput?, interactor: NewsFeedInteractorInput?, category: CategoryModel) {
        self.output = output
        self.interactor = interactor
        self.categoryModel = category
    }
    
    private func createFetchRequest() -> NewsFeedModels.Request.Fetch.Model {
        let searchText = output?.searchText
        let requestModel = NewsFeedModels.Request.Fetch.Model(category: categoryModel.category, searchText: searchText)
        
        return requestModel
    }
    
    private func createSaveRequest(with news: [News]) -> NewsFeedModels.Request.Save.Model {
        let requestModel = NewsFeedModels.Request.Save.Model(news: news)
        
        return requestModel
    }
}

extension NewsFeedPresenter: NewsFeedInput {
    
    var newsList: [News] {
        get {
            return news
        }
    }
    
    var title: String? {
        get {
            return categoryModel.title
        }
    }
    
    var showSearchBar: Bool {
        get {
            return categoryModel.category == .search
        }
    }
    
    func getStarted() {
        update()
    }
    
    func update() {
        output?.startRefresh()
        
        let requestModel = createFetchRequest()
        interactor?.fetchNews(with: requestModel)
    }
    
    func selectItem(at indexPath: IndexPath) {
        let selectedNews = news[indexPath.row]
        
        let requestModel = createSaveRequest(with: [selectedNews])
        interactor?.addNews(with: requestModel)
        
        router.showDetail(news: selectedNews)
    }
}

extension NewsFeedPresenter: NewsFeedInteractorOutput {
    
    func didReceive(response: NewsFeedModels.Response.Model) {
        output?.endRefresh()
        
        if let error = response.errorModel {
            output?.showAlert(with: error.status, message: error.message)
            return
        }
        
        news = response.newslist
        output?.reloadData()
    }
}
