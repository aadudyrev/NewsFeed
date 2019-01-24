//
//  RemoteDataSourceLoader.swift
//  NewsFeed
//
//  Created by Admin on 22/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

protocol RemoteDataSourceLoader {
    func fetchArticles(with requestModel: NetworkModels.Request.Fetch.News.Model, complition: @escaping (NetworkModels.Response.News.Model) -> ())
}
