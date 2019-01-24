//
//  CoreDataModels.swift
//  NewsFeed
//
//  Created by Admin on 19/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation



enum LocalDataSourceModel {
    
    enum Request {

        enum Fetch {
            
            struct Model {
                let fetchLimit: Int?
                let suchAsNews: [LocalDataSourceNews]?
            }
        }
        
        enum Save {
            
            struct Model {
                let newsList: [LocalDataSourceNews]
            }
        }
        
        enum Remove {
            
            struct Model {
                let newsList: [LocalDataSourceNews]
            }
        }
    }
    
    enum Response {
        
        struct Model {
            let newsList: [LocalDataSourceNews]?
        }
    }
}
