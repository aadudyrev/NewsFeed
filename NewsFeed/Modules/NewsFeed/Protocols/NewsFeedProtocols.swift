//
//  NewsFeedProtocols.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation




enum NewsFeedAction {
    case remove
    case add
}

protocol NewsFeedInput {
    var newsList: [News] { get }
    var title: String? { get }
    var showSearchBar: Bool { get }
    
    func getStarted()
    func update()
    func selectItem(at indexPath: IndexPath)
    
    func actionsForObject(at indexPath: IndexPath) -> [NewsFeedAction]
    func perform(action: NewsFeedAction, for indexPath: IndexPath)
}

protocol NewsFeedOutput: class {
    var searchText: String? { get }
    
    func showAlert(with title: String?, message: String?)
    func startRefresh()
    func endRefresh()
    func reloadData()
    func removeObject(at indexPath: IndexPath)
}




protocol NewsFeedInteractorInput {
    func fetchNews(with newsFeedRequest: NewsFeedModel.Request.Fetch.Model)
    func addNews(with newsFeedRequest: NewsFeedModel.Request.Save.Model)
    func removeNews(with newsFeedRequest: NewsFeedModel.Request.Remove.Model)
    func alreadyExist(_ request: NewsFeedModel.Request.Exist.Model) -> Bool
}

protocol NewsFeedInteractorOutput: class {
    func didReceive(response: NewsFeedModel.Response.Model)
}
