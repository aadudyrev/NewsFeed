//
//  CoreDataModels.swift
//  NewsFeed
//
//  Created by Admin on 19/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation



enum LocalStorageModels {
    
    enum Request {

        enum Fetch {
            
            struct Model {
                let fetchLimit: Int?
                let keys: [String]? // unique keys for news // AnyObject?
            }
        }
        
        enum Save {
            
            struct Model {
                let newsList: [News]
            }
        }
        
        enum Remove {
            
            struct Model {
                let newsList: [News]
            }
        }
    }
    
    enum Response {
        
        struct Model {
            let newsList: [News]?
        }
    }
}
