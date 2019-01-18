//
//  NetworkService.swift
//  ADExperience
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 aadudyrev. All rights reserved.
//

import Foundation

final class NetworkService {
    
    private let session = URLSession(configuration: .default)
    
    func send(request: URLRequest, complition: @escaping Complition) {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                complition(data, NetworkError.UnknownError(error))
                return
            }
            // проверим статус код
            if let httpResponse = response as? HTTPURLResponse {
                
                let statusCode = httpResponse.statusCode
                
                if successRange.contains(statusCode) {
                    
                    complition(data, nil)
                    
                } else {
                    
                    complition(data, NetworkError.ResponseError(statusCode))
                }
                
            } else {
                
                complition(data, NetworkError.InvalidResponse(response))
            }
        }
        
        print("send request to URL: \(request.url!.absoluteString), \nheaders: \(request.allHTTPHeaderFields ?? [:])")
        task.resume()
    }
}
