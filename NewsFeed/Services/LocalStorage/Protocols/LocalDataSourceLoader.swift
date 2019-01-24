//
//  LocalDataSourceLoader.swift
//  NewsFeed
//
//  Created by Admin on 23/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

enum LocalDataSourceRequest {
    case save(LocalDataSourceModel.Request.Save.Model)
    case fetch(LocalDataSourceModel.Request.Fetch.Model)
    case remove(LocalDataSourceModel.Request.Remove.Model)
}

protocol LocalDataSourceLoader {
    @discardableResult
    func performTask(with request: LocalDataSourceRequest) -> LocalDataSourceModel.Response.Model?
}
