//
//  NetworkServiceRequestBuilder.swift
//  ADExperience
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 aadudyrev. All rights reserved.
//

import Foundation

class NetworkServiceRequestBuilder {
    
    func buildRequest(with endPoint: EndPointProtocol, parameters: KeyValues?, headers: KeyValues?) throws -> URLRequest {
        guard var url = URL(string: endPoint.baseURL) else {
            throw NetworkError.InvalidURL(endPoint.baseURL)
        }
        url.appendPathComponent(endPoint.endPointPath)
        
        // поставим дефолтные значения
        let newParameters = setDefault(values: endPoint.defaultParameters, to: parameters)
        let newHeaders = setDefault(values: endPoint.defaultHeaders, to: headers)
        
        // проверим обязательные значения
        do {
            try checkRequared(values: endPoint.requaredParameters, in: newParameters)
            try checkRequared(values: endPoint.requaredHeaders, in: newHeaders)
        } catch {
            throw error
        }
        
        // соберем URL
        guard var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkError.InvalidURL(url.absoluteString)
        }
        var queryItems = [URLQueryItem]()
        for value in newParameters {
            let item = URLQueryItem(name: value.key, value: value.value)
            queryItems.append(item)
        }
        urlComp.queryItems = queryItems
        
        guard let queryURL = urlComp.url else {
            throw NetworkError.InvalidURL(urlComp.url?.absoluteString)
        }
        
        var request = URLRequest(url: queryURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        for header in newHeaders {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    private func setDefault(values: KeyValues?, to dict: KeyValues?) -> KeyValues {
        var dict = dict ?? KeyValues()
        
        if let values = values {
            
            for pair in values {
                if dict.keys.contains(pair.key) == false {
                    dict[pair.key] = pair.value
                }
            }
        }
        
        return dict
    }
    
    private func checkRequared(values: Values?, in dict: KeyValues) throws {
        if let reqValues = values {
            
            let keys = dict.keys
            
            for value in reqValues {
                if keys.contains(value) == false {
                    // нет обязательного параметра
                    throw NetworkError.MissingRequaredParameter(value)
                }
            }
        }
    }
    
}
