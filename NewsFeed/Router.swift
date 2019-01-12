//
//  Router.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

class Router {
    
    static let shared = Router()
    
    var rootViewController: UINavigationController?
    
    private init() {

    }
    
    func setRoot(for window: UIWindow) {
        
        let categoriesVC = CategoriesViewController.loadFromNib()
        rootViewController = UINavigationController(rootViewController: categoriesVC)
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
 
    func showNewsFeed(with category: CategoryModel) {
        guard let rootVC = rootViewController else { return }
        rootVC.popToRootViewController(animated: false)
        
        let newsFeed = NewsFeedViewController.loadFromNib()
        newsFeed.category = category
        rootVC.pushViewController(newsFeed, animated: true)
    }
    
    func showDetail(news: News) {
        
    }
}
