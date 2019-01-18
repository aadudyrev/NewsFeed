//
//  NetworkServiceProtocols.swift
//  ADExperience
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 aadudyrev. All rights reserved.
//

import Foundation

protocol EndPointProtocol {
    var httpMethod : HTTPMethod { get }
    var baseURL : String { get }
    var endPointPath : String { get }
    var defaultParameters : KeyValues? { get }
    var requaredParameters : Values? { get }
    var defaultHeaders : KeyValues? { get }
    var requaredHeaders : Values? { get }
}

protocol ItSelfDecodable: Decodable {
    static func getDecoder() -> JSONDecoder
}

extension ItSelfDecodable {
    static func getDecoder() -> JSONDecoder {
        return JSONDecoder()
    }
}
