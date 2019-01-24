//
//  NewsFeedModels.swift
//  NewsFeed
//
//  Created by Admin on 18/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

enum NewsFeedModels {
    
    enum Request {
        
        enum Fetch {
            
            struct Model {
                let category: NewsCategory
                let searchText: String?
            }
        }
        
        enum Save {
            
            struct Model {
                let news: [News]
            }
        }
    }
    
    enum Response {
        
        struct Model {
            let newslist: [News]
            let errorModel: NewsError?
        }
    }
}
