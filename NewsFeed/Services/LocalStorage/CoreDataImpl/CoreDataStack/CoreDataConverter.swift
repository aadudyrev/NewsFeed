//
//  CoreDataConverter.swift
//  NewsFeed
//
//  Created by Admin on 24/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class CoreDataConverter {
    
    func convertToResponseNews(_ cdNews: CDNews) -> LocalDataSourceNews {
        let responseNews = LocalDataSourceNews(author: cdNews.author,
                                       title: cdNews.title,
                                       description: cdNews.descr,
                                       url: cdNews.url!,
                                       urlToImage: cdNews.urlToImage,
                                       publishedAt: cdNews.publishedAt,
                                       content: cdNews.content)
        return responseNews
    }
    
    func convet(requestNews: LocalDataSourceNews, to cdNews: CDNews) {
        cdNews.author = requestNews.author
        cdNews.title = requestNews.title
        cdNews.url = requestNews.url
        cdNews.urlToImage = requestNews.urlToImage
        cdNews.descr = requestNews.description
        cdNews.publishedAt = requestNews.publishedAt
        cdNews.content = requestNews.content
    }
}
