//
//  NetworkModel.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation



enum NetworkModels {
    
    enum Request {

        enum Fetch {
            
            enum News {
                
                struct Model {
                    let endPoint: NewsEndPoint
                    let category: NewsCategory?
                    let searchText: String?
                    let country: String?
                }
            }
        }
    }
    
    enum Response {
        
        enum News {
            
            struct Model {
                let articles: Articles?
                let errorModel: NewsError?
            }
        }
    }
}
