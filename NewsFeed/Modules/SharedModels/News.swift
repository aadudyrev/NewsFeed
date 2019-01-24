//
//  News.swift
//  NewsFeed
//
//  Created by Admin on 24/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

struct News {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
}

extension News: Equatable {
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.url == rhs.url
    }
}

// MARK: Converter
extension News {
    
    static func transform(from anotherNews: RemoteDataSourceNews?) -> News? {
        guard let RemoteDataSourceNews = anotherNews else { return nil }
        let source = Source.transform(from: anotherNews?.source)
        let news = News(source: source,
                        author: RemoteDataSourceNews.author,
                        title: RemoteDataSourceNews.title,
                        description: RemoteDataSourceNews.description,
                        url: RemoteDataSourceNews.url ?? "",
                        urlToImage: RemoteDataSourceNews.urlToImage,
                        publishedAt: RemoteDataSourceNews.publishedAt,
                        content: RemoteDataSourceNews.content)
        return news
    }
    
    static func transform(from anotherNews: LocalDataSourceNews?) -> News? {
        guard let localNews = anotherNews else { return nil }
        let news = News(source: nil,
                        author: localNews.author,
                        title: localNews.title,
                        description: localNews.description,
                        url: localNews.url,
                        urlToImage: localNews.urlToImage,
                        publishedAt: localNews.publishedAt,
                        content: localNews.content)
        return news
    }
    
    static func transformToLocalDataSourceNews(_ news: News?) -> LocalDataSourceNews? {
        guard let news = news else { return nil }
        let localNews = LocalDataSourceNews(author: news.author,
                                    title: news.title,
                                    description: news.description,
                                    url: news.url,
                                    urlToImage: news.urlToImage,
                                    publishedAt: news.publishedAt,
                                    content: news.content)
        return localNews
    }
}
