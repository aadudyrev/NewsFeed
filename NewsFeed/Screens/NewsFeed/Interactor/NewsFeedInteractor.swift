//
//  NewsFeedInteractor.swift
//  NewsFeed
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class NewsFeedInteractor {
    
    weak var output: NewsFeedInteractorOutput?
    private let networkManager: RemoteDataSourceLoader?
    private let localDataSource: LocalDataSourceLoader?
    
    init(with output: NewsFeedInteractorOutput? = nil, networkManager: RemoteDataSourceLoader?, localDataSource: LocalDataSourceLoader?) {
        self.output = output
        self.networkManager = networkManager
        self.localDataSource = localDataSource
    }
    
    private func createNetworkRequest(from request: NewsFeedModels.Request.Fetch.Model) -> NetworkModels.Request.Fetch.News.Model {
        var endPoint: NewsEndPoint = .TopHeadlines
        var category: NewsCategory? = request.category
        var searchText: String? = nil
        
        switch request.category {
        case .search:
            endPoint = .Everything
            category = nil
            searchText = request.searchText
        default:
            break
        }
        
        let networkRequest = NetworkModels.Request.Fetch.News.Model(endPoint: endPoint, category: category, searchText: searchText, country: nil)
        return networkRequest
    }
    
    private func createFetchLocalRequest(from request: NewsFeedModels.Request.Fetch.Model) -> LocalStorageModels.Request.Fetch.Model {
        let localRequest = LocalStorageModels.Request.Fetch.Model(fetchLimit: nil, keys: nil)
        return localRequest
    }
    
    private func createSaveLocalRequest(from request: NewsFeedModels.Request.Save.Model) -> LocalStorageModels.Request.Save.Model {
        let localRequest = LocalStorageModels.Request.Save.Model(newsList: request.news)
        return localRequest
    }
    
    private func transformNetwork(response: NetworkModels.Response.News.Model) -> NewsFeedModels.Response.Model {
        guard let articles = response.articles?.articles else {
            let newsFeedResponse = NewsFeedModels.Response.Model(newslist: [], errorModel: response.errorModel)
            return newsFeedResponse
        }
        
        let newsFeedResponse = NewsFeedModels.Response.Model(newslist: articles, errorModel: nil)
        return newsFeedResponse
    }
    
    private func transformLocal(response: LocalStorageModels.Response.Model) -> NewsFeedModels.Response.Model {
        guard let newsList = response.newsList else {
            let newsFeedResponse = NewsFeedModels.Response.Model(newslist: [], errorModel: nil)
            return newsFeedResponse
        }
        
        let newsFeedResponse = NewsFeedModels.Response.Model(newslist: newsList, errorModel: nil)
        return newsFeedResponse
    }
}

extension NewsFeedInteractor: NewsFeedInteractorInput {

    func fetchNews(with newsFeedRequest: NewsFeedModels.Request.Fetch.Model) {
        switch newsFeedRequest.category {
        case .saved:
            fetchLocal(with: newsFeedRequest)
        default:
            fetchRemote(with: newsFeedRequest)
        }
    }
    
    func addNews(with newsFeedRequest: NewsFeedModels.Request.Save.Model) {
        let localRequest = createSaveLocalRequest(from: newsFeedRequest)
        localDataSource?.performTask(with: .save(localRequest), complition: { (localResponse) in
            
        })
    }
    
    private func fetchRemote(with request: NewsFeedModels.Request.Fetch.Model) {
        let networkRequest = createNetworkRequest(from: request)
        
        networkManager?.fetchArticles(with: networkRequest) { [weak self] (networkResponse) in
            guard let newsFeedResponse = self?.transformNetwork(response: networkResponse) else {
                return
            }
            self?.output?.didReceive(response: newsFeedResponse)
        }
    }
    
    private func fetchLocal(with request: NewsFeedModels.Request.Fetch.Model) {
        let localRequest = createFetchLocalRequest(from: request)
        
        localDataSource?.performTask(with: .fetch(localRequest), complition: { [weak self] (localResponse) in
            guard let newsFeedResponse = self?.transformLocal(response: localResponse) else {
                return
            }
            
            self?.output?.didReceive(response: newsFeedResponse)
        })
    }
}
