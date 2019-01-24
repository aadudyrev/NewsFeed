//
//  NetworkManager.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class NetworkManager {
    private let service = NetworkServiceManager<RemoteDataSourceArticles, RemoteDataSourceNewsError>()
}

extension NetworkManager: RemoteDataSourceLoader {
    
    func fetchArticles(with requestModel: RemoteDataSourceModel.Request.Fetch.News.Model, complition: @escaping (RemoteDataSourceModel.Response.News.Model) -> ()) {
        let params = getParams(from: requestModel)
        
        service.sendRequest(to: requestModel.endPoint, parameters: params, headers: nil) { (response) in
            
            let artilcles: RemoteDataSourceArticles?
            let newsError: RemoteDataSourceNewsError?
            
            switch response {
            case .Success(let arts):
                artilcles = arts
                newsError = nil
                
            case .Error(let error, let errorModel):
                print(error.localizedDescription)
                print(errorModel ?? "")
                
                artilcles = nil
                newsError = errorModel
            }
            
            let responseModel = RemoteDataSourceModel.Response.News.Model(articles: artilcles, errorModel: newsError)
            complition(responseModel)
        }
    }
}

private extension NetworkManager {
    
    func getParams(from requestModel: RemoteDataSourceModel.Request.Fetch.News.Model) -> KeyValues {
        var params = KeyValues()
        
        if let category = requestModel.category {
            params["category"] = category.rawValue
        }
        
        if let searchText = requestModel.searchText {
            params["q"] = searchText
        }
        
        if let country = requestModel.country {
            params["country"] = country
        }
        
        return params
    }
}
