//
//  Articles.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

struct RemoteDataSourceArticles: ItSelfDecodable {
    let status: String
    let totalResults: Int
    let articles: [RemoteDataSourceNews]?
    
    static func getDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }
}
