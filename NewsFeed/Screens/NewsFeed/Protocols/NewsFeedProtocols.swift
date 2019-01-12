//
//  NewsFeedProtocols.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

protocol NewsFeedInput {
    func getStarted()
    func update()
    func getNews() -> [News]?
    func selectItem(at indexPath: IndexPath)
}

protocol NewsFeedOutput {
    func showSearchBar()
    func showAlert(with title: String?, message: String?)
    func startRefresh()
    func endRefresh()
    func reloadData()
}
