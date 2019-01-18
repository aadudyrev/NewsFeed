//
//  NewsFeedModels.swift
//  NewsFeed
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

enum NewsFeedModels {
    
    struct Request {
        let category: NewsCategory
        let searchText: String?
    }
    
    struct Response {
        let news: [News]?
        let errorModel: NewsError?
    }
}
