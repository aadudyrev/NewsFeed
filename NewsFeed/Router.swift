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
    private let linker = Linker.shared
    
    
    var rootViewController: UINavigationController?
    
    private init() {

    }
    
    func setRoot(for window: UIWindow) {
        let categoriesVC = linker.createCategoriesViewController()
        rootViewController = UINavigationController(rootViewController: categoriesVC)
        rootViewController?.navigationBar.prefersLargeTitles = true
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
 
    func showNewsFeed(with category: CategoryModel) {
        guard let rootVC = rootViewController else { return }
        
        let newsFeed = linker.createNewsFeedViewController(with: category)
        rootVC.popToRootViewController(animated: false)
        rootVC.pushViewController(newsFeed, animated: true)
    }
    
    func showDetail(news: News) {
        guard let rootVC = rootViewController else { return }
        
        let newsDetail = linker.createNewsDetailViewController(with: news)
        rootVC.pushViewController(newsDetail, animated: true)
    }
    
    func open(url urlString: String?) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
