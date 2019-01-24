//
//  LocalDataSourceLoader.swift
//  NewsFeed
//
//  Created by Admin on 23/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

enum LocalDataSourceRequest {
    case save(LocalStorageModels.Request.Save.Model)
    case fetch(LocalStorageModels.Request.Fetch.Model)
    case remove(LocalStorageModels.Request.Remove.Model)
}

protocol LocalDataSourceLoader {
    func performTask(with request: LocalDataSourceRequest, complition: @escaping (LocalStorageModels.Response.Model) -> ())
}
