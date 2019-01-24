//
//  NetworkHelper.swift
//  ADExperience
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 aadudyrev. All rights reserved.
//

import Foundation

let successRange = CountableRange(200...299)

typealias Complition = (Data?, NetworkError?) -> Void
typealias KeyValues = [String : String]
typealias Values = [String]

public enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
