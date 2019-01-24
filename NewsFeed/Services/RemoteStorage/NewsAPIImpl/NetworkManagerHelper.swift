//
//  NetworkManagerHelper.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

enum RemoteNewsEndPoint {
    case TopHeadlines
    case Everything
    case Sources
}

extension RemoteNewsEndPoint: EndPointProtocol {
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var baseURL: String {
        return "https://newsapi.org/v2"
    }
    
    var endPointPath: String {
        switch self {
        case .TopHeadlines:
            return "top-headlines"
        case .Everything:
            return "everything"
        case .Sources:
            return "sources"
        }
    }
    
    var defaultParameters: KeyValues? {
        return nil//["country" : "ru"]
    }
    
    var requaredParameters: Values? {
        return nil
    }
    
    var defaultHeaders: KeyValues? {
        return ["X-Api-Key" : "a5a34baa13db4a0da95e74cc73d6a1f9"]
    }
    
    var requaredHeaders: Values? {
        return ["X-Api-Key"]
    }
    
    
}
