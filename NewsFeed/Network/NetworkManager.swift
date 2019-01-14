//
//  NetworkManager.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class NetworkManager {
    private let service = NetworkServiceManager<Articles, NewsError>()
    
    func getNews(with requestModel: NetworkRequestModel, complition: @escaping (Articles?, NewsError?) -> ()) {
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
        
        service.sendRequest(to: requestModel.endPoint, parameters: params, headers: nil) { (response) in
            
            switch response {
            case .Success(let articles):
                complition(articles, nil)
                
            case .Error(let error, let newsError):
                print(error.localizedDescription)
                print(newsError ?? "")
                
                complition(nil, newsError)
            }
        }
    }
}
