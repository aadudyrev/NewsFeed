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
    
    func getNews(for category: NewsCategory?, complition: @escaping (Articles?, NewsError?) -> ()) {
        let params = category != nil ? ["category" : category!.rawValue] : nil
        service.sendRequest(to: NetworkManagerHelper.TopHeadlines, parameters: params, headers: nil) { (response) in
            
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
