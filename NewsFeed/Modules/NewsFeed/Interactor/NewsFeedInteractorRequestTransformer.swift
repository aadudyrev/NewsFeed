//
//  NewsFeedRequestTransformer.swift
//  NewsFeed
//
//  Created by Admin on 24/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class NewsFeedInteractorRequestTransformer {
    
    func transformRemote(response: RemoteDataSourceModel.Response.News.Model) -> NewsFeedModel.Response.Model {
        guard let articles = response.articles?.articles else {
            let remoteError = response.errorModel
            let errorModel = NewsError.transform(from: remoteError)
            let newsFeedResponse = NewsFeedModel.Response.Model(newslist: [], errorModel: errorModel)
            return newsFeedResponse
        }
        
        let newsList = articles.compactMap { News.transform(from: $0) }
        let newsFeedResponse = NewsFeedModel.Response.Model(newslist: newsList, errorModel: nil)
        return newsFeedResponse
    }
    
    func transformLocal(response: LocalDataSourceModel.Response.Model) -> NewsFeedModel.Response.Model {
        guard let localNewsList = response.newsList else {
            let newsFeedResponse = NewsFeedModel.Response.Model(newslist: [], errorModel: nil)
            return newsFeedResponse
        }
        
        let newsList = localNewsList.compactMap { News.transform(from: $0) }
        let newsFeedResponse = NewsFeedModel.Response.Model(newslist: newsList, errorModel: nil)
        return newsFeedResponse
    }
}
