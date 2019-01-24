//
//  NewsFeedRequestBuilder.swift
//  NewsFeed
//
//  Created by Admin on 24/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class NewsFeedInteractorRequestBuilder {
    
    func buildRemoteRequest(from request: NewsFeedModel.Request.Fetch.Model) -> RemoteDataSourceModel.Request.Fetch.News.Model {
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
    
    func buildFetchLocalRequest(from request: NewsFeedModel.Request.Fetch.Model) -> LocalDataSourceModel.Request.Fetch.Model {
        let localRequest = LocalDataSourceModel.Request.Fetch.Model(fetchLimit: nil, suchAsNews: nil)
        return localRequest
    }
    
    func buildSaveLocalRequest(from request: NewsFeedModel.Request.Save.Model) -> LocalDataSourceModel.Request.Save.Model {
        let localNews = request.news.compactMap { News.transformToLocalDataSourceNews($0) }
        let localRequest = LocalDataSourceModel.Request.Save.Model(newsList: localNews)
        return localRequest
    }
    
    func buildRemoveLocalRequest(from request: NewsFeedModel.Request.Remove.Model) -> LocalDataSourceModel.Request.Remove.Model {
        let localNews = request.news.compactMap { News.transformToLocalDataSourceNews($0) }
        let localRequest = LocalDataSourceModel.Request.Remove.Model(newsList: localNews)
        return localRequest
    }
    
    func buildExistLocalRequest(from request: NewsFeedModel.Request.Exist.Model) -> LocalDataSourceModel.Request.Fetch.Model {
        let newsArr = [request.news]
        let suchAsNews = newsArr.compactMap { News.transformToLocalDataSourceNews($0) }
        let localRequest = LocalDataSourceModel.Request.Fetch.Model(fetchLimit: nil, suchAsNews: suchAsNews)
        return localRequest
    }
    
}
