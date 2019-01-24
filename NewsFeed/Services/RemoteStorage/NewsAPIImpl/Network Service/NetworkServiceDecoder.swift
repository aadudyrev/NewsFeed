//
//  NetworkServiceDecoder.swift
//  ADExperience
//
//  Created by Admin on 29/12/2018.
//  Copyright © 2018 aadudyrev. All rights reserved.
//

import Foundation

class NetworkServiceDecoder<T: ItSelfDecodable> {
    
    func decode(data: Data?) -> T? {
        guard let data = data else { return nil }
        let decoder = T.getDecoder()
        let decodableData = try? decoder.decode(T.self, from: data)
        return decodableData
    }
    
}
