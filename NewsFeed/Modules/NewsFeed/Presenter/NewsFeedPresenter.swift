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
    
    private func createRemoveRequest(with news: [News]) -> NewsFeedModels.Request.Remove.Model {
        let requestModel = NewsFeedModels.Request.Remove.Model(news: news)
        return requestModel
    }
    
    private func createExistRequest(with news: News) -> NewsFeedModels.Request.Exist.Model {
        let requestModel = NewsFeedModels.Request.Exist.Model(news: news)
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
        router.showDetail(news: selectedNews)
    }
    
    func actionsForObject(at indexPath: IndexPath) -> [NewsFeedAction] {
        let news = newsList[indexPath.row]
        let request = createExistRequest(with: news)
        if interactor?.existInLocalStorage(request) == true {
            return [.remove]
        }
        return [.add]
    }
    
    func perform(action: NewsFeedAction, for indexPath: IndexPath) {
        let newsForAction = newsList[indexPath.row]
        
        switch action {
        case .add:
            let requestModel = createSaveRequest(with: [newsForAction])
            interactor?.addNews(with: requestModel)
        case .remove:
            let requestModel = createRemoveRequest(with: [newsForAction])
            interactor?.removeNews(with: requestModel)
            
            if categoryModel.category == .saved {
                news.remove(at: indexPath.row)
                output?.removeObject(at: indexPath)
            }
        }
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
