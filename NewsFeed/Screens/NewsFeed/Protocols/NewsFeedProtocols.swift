//
//  NewsFeedProtocols.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

protocol NewsFeedInput {
    
    var newsList: [News] { get }
    var title: String? { get }
    var showSearchBar: Bool { get }
    
    func getStarted()
    func update()
    func selectItem(at indexPath: IndexPath)
}

protocol NewsFeedOutput: class {
    
    var searchText: String? { get }
    
    func showAlert(with title: String?, message: String?)
    func startRefresh()
    func endRefresh()
    func reloadData()
}
