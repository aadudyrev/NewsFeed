//
//  NewsDetailProtocols.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

protocol NewsDetailInput {
    func getStarted()
    func openNews()
}

protocol NewsDetailOutput: class {
    func configure(with news: News)
}
