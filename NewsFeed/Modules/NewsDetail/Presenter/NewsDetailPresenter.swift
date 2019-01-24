//
//  NewsDetailPresenter.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class NewsDetailPresenter {
    
    private let router = Router.shared
    private let currentNews: News
    private weak var output: NewsDetailOutput?
    
    init(with news: News, output: NewsDetailOutput) {
        self.currentNews = news
        self.output = output
    }
}

extension NewsDetailPresenter: NewsDetailInput {
    
    func getStarted() {
        output?.configure(with: currentNews)
    }
    
    func openNews() {
        router.open(url: currentNews.url)
    }
}
