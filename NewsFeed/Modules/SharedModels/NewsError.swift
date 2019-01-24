//
//  NewsError.swift
//  NewsFeed
//
//  Created by Admin on 24/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

struct NewsError {
    let status: String?
    let code: String?
    let message: String?
}

// MARK: Converter
extension NewsError {
    
    static func transform(from anotherError: RemoteDataSourceNewsError?) -> NewsError? {
        guard let networkError = anotherError else { return nil }
        let newsError = NewsError(status: networkError.status,
                                  code: networkError.code,
                                  message: networkError.message)
        return newsError
    }
}
