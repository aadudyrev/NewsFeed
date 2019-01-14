//
//  NetworkRequestModel.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

struct NetworkRequestModel {
    let endPoint: NewsEndPoint
    let category: NewsCategory?
    let searchText: String?
    let country: String?
}
