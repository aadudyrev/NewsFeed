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
    
    private var persistentContainer: NSPersistentContainer
    private var mainContext: NSManagedObjectContext {
        
        get {
            return persistentContainer.viewContext
        }
    }
    
    private let converter = CoreDataConverter()
    
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
    
    private func createNewsFetchRequest(from request: LocalDataSourceModel.Request.Fetch.Model) -> NSFetchRequest<CDNews> {
        let fetchRequest: NSFetchRequest<CDNews> = CDNews.fetchRequest()
        if let limit = request.fetchLimit {
            fetchRequest.fetchLimit = limit
        }
        
        if let suchAsNews = request.suchAsNews {
            let keys = getUniqueKeys(from: suchAsNews)
            fetchRequest.predicate = NSPredicate(format: "key IN %@", argumentArray: [keys])
        }
        
        return fetchRequest
    }
    
    // MARK: Unique key for CDNews
    private func setUniqueKey(for cdNews: CDNews) {
        let keyString = cdNews.url ?? ""
        cdNews.key = keyString
    }
    
    private func getUniqueKey(from news: LocalDataSourceNews) -> String {
        return news.url
    }
    
    private func getUniqueKeys(from news: [LocalDataSourceNews]) -> [String] {
        let keys = news.compactMap{ $0.url }
        return keys
    }
}

extension CoreDataManager: LocalDataSourceLoader {
    
    @discardableResult
    func performTask(with request: LocalDataSourceRequest) -> LocalDataSourceModel.Response.Model? {
        switch request {
        case .save(let requestModel):
            return saveNews(requestModel)
        case .fetch(let requestModel):
            return fetchNews(with: requestModel)
        case .remove(let requestModel):
            return removeNews(with: requestModel)
        }
    }
    
    private func saveNews(_ request: LocalDataSourceModel.Request.Save.Model) -> LocalDataSourceModel.Response.Model?  {
        var newsForSave = request.newsList
        
        let requestModel = LocalDataSourceModel.Request.Fetch.Model(fetchLimit: nil, suchAsNews: newsForSave)
        let fetchRequest = createNewsFetchRequest(from: requestModel)
        
        let savedCDNews = fetchCDNews(with: fetchRequest)
        let savedCDNewsKeys = savedCDNews.compactMap{ $0.key }
        newsForSave = newsForSave.filter{ savedCDNewsKeys.contains( getUniqueKey(from: $0) ) == false }
        newsForSave.forEach {
            let entityName = String(describing: CDNews.self)
            guard let cdNews = NSEntityDescription.insertNewObject(forEntityName: entityName, into: mainContext) as? CDNews else {
                return
            }
            converter.convet(requestNews: $0, to: cdNews)
            setUniqueKey(for: cdNews)
        }
        
        save(context: mainContext)
        
        return nil
    }
    
    private func fetchNews(with request: LocalDataSourceModel.Request.Fetch.Model) -> LocalDataSourceModel.Response.Model? {
        let fetchRequest = createNewsFetchRequest(from: request)
        let fetchedNews = fetchCDNews(with: fetchRequest)
        let newsForRespons = fetchedNews.compactMap{ self.converter.convertToResponseNews($0) }
        let response = LocalDataSourceModel.Response.Model(newsList: newsForRespons)
        return response
    }
    
    private func removeNews(with request: LocalDataSourceModel.Request.Remove.Model) -> LocalDataSourceModel.Response.Model?  {
        let newsForRemove = request.newsList
        
        let requestModel = LocalDataSourceModel.Request.Fetch.Model(fetchLimit: nil, suchAsNews: newsForRemove)
        let fetchRequest = createNewsFetchRequest(from: requestModel)
        
        let savedCDNews = fetchCDNews(with: fetchRequest)
        savedCDNews.forEach {
            mainContext.delete($0)
        }
        
        save(context: mainContext)
        
        return nil
    }
}
