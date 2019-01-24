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
    private let remoteDataSource: RemoteDataSourceLoader?
    private let localDataSource: LocalDataSourceLoader?
    
    init(with output: NewsFeedInteractorOutput? = nil, remoteDataSource: RemoteDataSourceLoader?, localDataSource: LocalDataSourceLoader?) {
        self.output = output
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    private func createRemoteRequest(from request: NewsFeedModels.Request.Fetch.Model) -> RemoteDataSourceModel.Request.Fetch.News.Model {
        var endPoint = RemoteNewsEndPoint.TopHeadlines
        var category = RemoteDataSourceNewsCategory(rawValue: request.category.rawValue)
        var searchText: String? = nil
        
        switch request.category {
        case .search:
            endPoint = .Everything
            category = nil
            searchText = request.searchText
        default:
            break
        }
        
        let remoteRequest = RemoteDataSourceModel.Request.Fetch.News.Model(endPoint: endPoint, category: category, searchText: searchText, country: nil)
        return remoteRequest
    }
    
    private func createFetchLocalRequest(from request: NewsFeedModels.Request.Fetch.Model) -> LocalDataSourceModel.Request.Fetch.Model {
        let localRequest = LocalDataSourceModel.Request.Fetch.Model(fetchLimit: nil, suchAsNews: nil)
        return localRequest
    }
    
    private func createSaveLocalRequest(from request: NewsFeedModels.Request.Save.Model) -> LocalDataSourceModel.Request.Save.Model {
        let localNews = request.news.compactMap { News.transformToLocalDataSourceNews($0) }
        let localRequest = LocalDataSourceModel.Request.Save.Model(newsList: localNews)
        return localRequest
    }
    
    private func createRemoveLocalRequest(from request: NewsFeedModels.Request.Remove.Model) -> LocalDataSourceModel.Request.Remove.Model {
        let localNews = request.news.compactMap { News.transformToLocalDataSourceNews($0) }
        let localRequest = LocalDataSourceModel.Request.Remove.Model(newsList: localNews)
        return localRequest
    }
    
    private func createExistLocalRequest(from request: NewsFeedModels.Request.Exist.Model) -> LocalDataSourceModel.Request.Fetch.Model {
        let newsArr = [request.news]
        let suchAsNews = newsArr.compactMap { News.transformToLocalDataSourceNews($0) }
        let localRequest = LocalDataSourceModel.Request.Fetch.Model(fetchLimit: nil, suchAsNews: suchAsNews)
        return localRequest
    }
    
    private func transformRemote(response: RemoteDataSourceModel.Response.News.Model) -> NewsFeedModels.Response.Model {
        guard let articles = response.articles?.articles else {
            let remoteError = response.errorModel
            let errorModel = NewsError.transform(from: remoteError)
            let newsFeedResponse = NewsFeedModels.Response.Model(newslist: [], errorModel: errorModel)
            return newsFeedResponse
        }
        
        let newsList = articles.compactMap { News.transform(from: $0) }
        let newsFeedResponse = NewsFeedModels.Response.Model(newslist: newsList, errorModel: nil)
        return newsFeedResponse
    }
    
    private func transformLocal(response: LocalDataSourceModel.Response.Model) -> NewsFeedModels.Response.Model {
        guard let localNewsList = response.newsList else {
            let newsFeedResponse = NewsFeedModels.Response.Model(newslist: [], errorModel: nil)
            return newsFeedResponse
        }
        
        let newsList = localNewsList.compactMap { News.transform(from: $0) }
        let newsFeedResponse = NewsFeedModels.Response.Model(newslist: newsList, errorModel: nil)
        return newsFeedResponse
    }
}

extension NewsFeedInteractor: NewsFeedInteractorInput {

    func fetchNews(with newsFeedRequest: NewsFeedModels.Request.Fetch.Model) {
        switch newsFeedRequest.category {
        case .saved:
            fetchFromLocalDS(with: newsFeedRequest)
        default:
            fetchFromRemoteDS(with: newsFeedRequest)
        }
    }
    
    func addNews(with newsFeedRequest: NewsFeedModels.Request.Save.Model) {
        let localRequest = createSaveLocalRequest(from: newsFeedRequest)
        _ = localDataSource?.performTask(with: .save(localRequest))
    }
    
    func removeNews(with newsFeedRequest: NewsFeedModels.Request.Remove.Model) {
        let localRequest = createRemoveLocalRequest(from: newsFeedRequest)
        _ = localDataSource?.performTask(with: .remove(localRequest))
    }
    
    func existInLocalStorage(_ request: NewsFeedModels.Request.Exist.Model) -> Bool {
        let localRequest = createExistLocalRequest(from: request)
        let localResponse = localDataSource?.performTask(with: .fetch(localRequest))
        
        return localResponse?.newsList?.count ?? 0 == 1
    }
    
    private func fetchFromRemoteDS(with request: NewsFeedModels.Request.Fetch.Model) {
        let remoteRequest = createRemoteRequest(from: request)
        
        remoteDataSource?.fetchArticles(with: remoteRequest) { [weak self] (remoteResponse) in
            guard let self = self else {
                return
            }
            
            let newsFeedResponse = self.transformRemote(response: remoteResponse)
            self.output?.didReceive(response: newsFeedResponse)
        }
    }
    
    private func fetchFromLocalDS(with request: NewsFeedModels.Request.Fetch.Model) {
        let localRequest = createFetchLocalRequest(from: request)
        guard let localResponse = localDataSource?.performTask(with: .fetch(localRequest)) else { return }
        
        let newsFeedResponse = transformLocal(response: localResponse)
        output?.didReceive(response: newsFeedResponse)
    }
}
