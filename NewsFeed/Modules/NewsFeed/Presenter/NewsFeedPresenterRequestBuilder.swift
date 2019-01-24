//
//  NewsFeedPresenterRequestBuilder.swift
//  NewsFeed
//
//  Created by Admin on 25/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class NewsFeedPresenterRequestBuilder {
    
    func createFetchRequest(with searchText: String?, categoryModel: CategoryModel) -> NewsFeedModel.Request.Fetch.Model {
        let requestModel = NewsFeedModel.Request.Fetch.Model(category: categoryModel.category, searchText: searchText)
        return requestModel
    }
    
    func createSaveRequest(with news: [News]) -> NewsFeedModel.Request.Save.Model {
        let requestModel = NewsFeedModel.Request.Save.Model(news: news)
        return requestModel
    }
    
    func createRemoveRequest(with news: [News]) -> NewsFeedModel.Request.Remove.Model {
        let requestModel = NewsFeedModel.Request.Remove.Model(news: news)
        return requestModel
    }
    
    func createExistRequest(with news: News) -> NewsFeedModel.Request.Exist.Model {
        let requestModel = NewsFeedModel.Request.Exist.Model(news: news)
        return requestModel
    }
    
}
