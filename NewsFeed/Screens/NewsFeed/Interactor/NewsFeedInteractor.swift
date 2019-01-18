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
    private let networkManager: NetworkManager
    
    init(with output: NewsFeedInteractorOutput? = nil, networkManager: NetworkManager) {
        self.output = output
        self.networkManager = networkManager
    }
    
    private func createNetworkRequest(from request: NewsFeedModels.Request) -> NetworkModels.Request {
        var endPoint: NewsEndPoint = .TopHeadlines
        var category: NewsCategory? = request.category
        var searchText: String? = nil
        
        switch request.category {
        case .search:
            endPoint = .Everything
            category = nil
            searchText = request.searchText
        case .saved:
            break
        default:
            break
        }
        
        let networkRequest = NetworkModels.Request(endPoint: endPoint, category: category, searchText: searchText, country: nil)
        return networkRequest
    }
}

extension NewsFeedInteractor: NewsFeedInteractorInput {
    
    func fetchNews(with newsFeedRequest: NewsFeedModels.Request) {
        let networkRequest = createNetworkRequest(from: newsFeedRequest)
        
        networkManager.getNews(with: networkRequest) { [weak self] (networkResponse) in
            let newsFeedResponse = NewsFeedModels.Response(news: networkResponse.articles?.articles, errorModel: networkResponse.errorModel)
            self?.output?.didReceive(response: newsFeedResponse)
        }
    }
}
