//
//  NetworkServiceManager.swift
//  ADExperience
//
//  Created by Admin on 27/12/2018.
//  Copyright © 2018 aadudyrev. All rights reserved.
//

import Foundation

class NetworkServiceManager<SuccessType: ItSelfDecodable, ErrorType: ItSelfDecodable> {
    
    func sendRequest(to endPoint: EndPointProtocol, parameters: KeyValues?, headers: KeyValues?, complition: @escaping (NetworkResponseStatus<SuccessType, ErrorType>) -> Void) {
        let requestBuilder = NetworkServiceRequestBuilder()
        do {
            let request = try requestBuilder.buildRequest(with: endPoint, parameters: parameters, headers: headers)
            let service = NetworkService()
            
            service.send(request: request) { (data, error) in
                
                if let error = error {
                    
                    let decoder = NetworkServiceDecoder<ErrorType>()
                    let errorData = decoder.decode(data: data)
                    complition(NetworkResponseStatus.Error(error, errorData))
                
                } else {
                    
                    let decoder = NetworkServiceDecoder<SuccessType>()
                    let successData = decoder.decode(data: data)
                    complition(NetworkResponseStatus.Success(successData))
                }
            }
            
        } catch {
            
            complition(NetworkResponseStatus.Error(error as! NetworkError, nil))
        }
    }
}
