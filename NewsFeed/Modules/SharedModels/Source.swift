//
//  Source.swift
//  NewsFeed
//
//  Created by Admin on 24/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

struct Source {
    let id: String?
    let name: String?
    let description: String?
    let url: String
    let category: String?
    let language: String?
    let country: String?
}

// MARK: Converter
extension Source {
    
    static func transform(from anotherSource: RemoteDataSourceSource?) -> Source? {
        guard let networSource = anotherSource else { return nil }
        let source = Source(id: networSource.id,
                            name: networSource.name,
                            description: networSource.description,
                            url: networSource.url ?? "",
                            category: networSource.category,
                            language: networSource.language,
                            country: networSource.country)
        return source
    }
}
