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
    
    private let requestBuilder = NewsFeedInteractorRequestBuilder()
    private let requestTransformer = NewsFeedInteractorRequestTransformer()
    
    init(with output: NewsFeedInteractorOutput? = nil, remoteDataSource: RemoteDataSourceLoader?, localDataSource: LocalDataSourceLoader?) {
        self.output = output
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
}

extension NewsFeedInteractor: NewsFeedInteractorInput {

    func fetchNews(with newsFeedRequest: NewsFeedModel.Request.Fetch.Model) {
        switch newsFeedRequest.category {
        case .saved:
            fetchFromLocalDS(with: newsFeedRequest)
        default:
            fetchFromRemoteDS(with: newsFeedRequest)
        }
    }
    
    func addNews(with newsFeedRequest: NewsFeedModel.Request.Save.Model) {
        let localRequest = requestBuilder.buildSaveLocalRequest(from: newsFeedRequest)
        _ = localDataSource?.performTask(with: .save(localRequest))
    }
    
    func removeNews(with newsFeedRequest: NewsFeedModel.Request.Remove.Model) {
        let localRequest = requestBuilder.buildRemoveLocalRequest(from: newsFeedRequest)
        _ = localDataSource?.performTask(with: .remove(localRequest))
    }
    
    func alreadyExist(_ request: NewsFeedModel.Request.Exist.Model) -> Bool {
        let localRequest = requestBuilder.buildExistLocalRequest(from: request)
        let localResponse = localDataSource?.performTask(with: .fetch(localRequest))
        
        return localResponse?.newsList?.count ?? 0 == 1
    }
    
    private func fetchFromRemoteDS(with request: NewsFeedModel.Request.Fetch.Model) {
        let remoteRequest = requestBuilder.buildRemoteRequest(from: request)
        
        remoteDataSource?.fetchArticles(with: remoteRequest) { [weak self] (remoteResponse) in
            guard let self = self else {
                return
            }
            
            let newsFeedResponse = self.requestTransformer.transformRemote(response: remoteResponse)
            self.output?.didReceive(response: newsFeedResponse)
        }
    }
    
    private func fetchFromLocalDS(with request: NewsFeedModel.Request.Fetch.Model) {
        let localRequest = requestBuilder.buildFetchLocalRequest(from: request)
        guard let localResponse = localDataSource?.performTask(with: .fetch(localRequest)) else { return }
        
        let newsFeedResponse = requestTransformer.transformLocal(response: localResponse)
        output?.didReceive(response: newsFeedResponse)
    }
}
