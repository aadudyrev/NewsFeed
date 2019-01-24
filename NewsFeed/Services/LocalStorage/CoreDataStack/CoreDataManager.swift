//
//  CoreDataManager.swift
//  NewsFeed
//
//  Created by Admin on 19/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    var persistentContainer: NSPersistentContainer
    var mainContext: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "NewsFeed")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
    
    private func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func fetchCDNews(with request: NSFetchRequest<CDNews>) -> [CDNews] {
        do {
            let objects = try mainContext.fetch(request)
            return objects
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func createNewsFetchRequest(from request: LocalStorageModels.Request.Fetch.Model) -> NSFetchRequest<CDNews> {
        let fetchRequest: NSFetchRequest<CDNews> = CDNews.fetchRequest()//NSFetchRequest<NSManagedObject>(entityName: entityName)
        if let limit = request.fetchLimit {
            fetchRequest.fetchLimit = limit
        }
        
        if let keys = request.keys {
            fetchRequest.predicate = NSPredicate(format: "key IN %@", argumentArray: [keys])
        }
        
        return fetchRequest
    }
    
    private func convertNewsToResponsNews(_ news: CDNews) -> News {
        let rNews = News(source: nil,
                         author: news.author,
                         title: news.title,
                         description: news.descr,
                         url: news.url,
                         urlToImage: news.urlToImage,
                         publishedAt: news.publishedAt,
                         content: news.content)
        return rNews
    }
    
    private func convet(news: News, to cdNews: CDNews) {
        cdNews.author = news.author
        cdNews.title = news.title
        cdNews.url = news.url
        cdNews.urlToImage = news.urlToImage
        cdNews.descr = news.description
        cdNews.publishedAt = news.publishedAt ?? Date()
        cdNews.content = news.content
    }
    
    private func setUniqueKey(for cdNews: CDNews) {
        let keyString = cdNews.url ?? ""
        cdNews.key = keyString
    }
    
    private func getUniqueKeys(from news: [News]) -> [String] {
        let keys = news.compactMap{ $0.url }
        return keys
    }
}

extension CoreDataManager: LocalDataSourceLoader {
    
    func performTask(with request: LocalDataSourceRequest, complition: @escaping (LocalStorageModels.Response.Model) -> ()) {
        switch request {
        case .save(let requestModel):
            saveNews(requestModel)
        case .fetch(let requestModel):
            fetchNews(with: requestModel, complition: complition)
        case .remove(let requestModel):
            removeNews(with: requestModel)
        }
    }
    
    private func saveNews(_ request: LocalStorageModels.Request.Save.Model) {
        var newsForSave = request.newsList
        let keys = getUniqueKeys(from: newsForSave)
        
        let requestModel = LocalStorageModels.Request.Fetch.Model(fetchLimit: nil, keys: keys)
        let fetchRequest = createNewsFetchRequest(from: requestModel)
        
        let savedCDNews = fetchCDNews(with: fetchRequest)
        let savedCDNewsKeys = savedCDNews.compactMap{ $0.url }
        //FIXME: $0.url to non optional string
        newsForSave = newsForSave.filter{ savedCDNewsKeys.contains( $0.url! ) == false }
        newsForSave.forEach {
            let entityName = String(describing: CDNews.self)
            guard let cdNews = NSEntityDescription.insertNewObject(forEntityName: entityName, into: mainContext) as? CDNews else {
                return
            }
            convet(news: $0, to: cdNews)
        }
        
        save(context: mainContext)
    }
    
    private func fetchNews(with request: LocalStorageModels.Request.Fetch.Model, complition: @escaping (LocalStorageModels.Response.Model) -> ()) {
        let fetchRequest = createNewsFetchRequest(from: request)
        let fetchedNews = fetchCDNews(with: fetchRequest)
        let newsForRespons = fetchedNews.compactMap{ self.convertNewsToResponsNews($0) }
        complition(LocalStorageModels.Response.Model(newsList: newsForRespons))
    }
    
    private func removeNews(with request: LocalStorageModels.Request.Remove.Model) {
        let newsForRemove = request.newsList
        let keys = getUniqueKeys(from: newsForRemove)
        
        let requestModel = LocalStorageModels.Request.Fetch.Model(fetchLimit: nil, keys: keys)
        let fetchRequest = createNewsFetchRequest(from: requestModel)
        
        let savedCDNews = fetchCDNews(with: fetchRequest)
        savedCDNews.forEach {
            mainContext.delete($0)
        }
        
        save(context: mainContext)
    }
}
