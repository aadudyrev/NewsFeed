//
//  SimpleDownloader.swift
//  NewsFeed
//
//  Created by Admin on 15/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit.UIApplication

class SimpleDownloader<T: PendingAnObject> {
    
    private var cache = NSCache<NSString, ObjectContainer>()
    private let queue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 7
        q.qualityOfService = .default
        
        return q
    }()
    
    private let weakRecieverToWeakURL = NSMapTable<AnyObject, NSString>.weakToWeakObjects()
    private var waitingSenders = [NSString : NSHashTable<AnyObject>]()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func clearCache() {
        cache.removeAllObjects()
    }
    
    func download(from urlStr: String?, receiver: T) {
        remove(receiver: receiver)
        
        let container = ObjectContainer()
        
        guard let urlString = urlStr else {
            container.status = .failed
            receiver.receive(objectWrapper: container.getStruct())
            return
        }
        
        let key = NSString(string: urlString)
        
        if let cachedContainer = cache.object(forKey: key) {
            if cachedContainer.status == .inProgress {
                add(receiver: receiver, for: key)
            }
            
            receiver.receive(objectWrapper: cachedContainer.getStruct())
            return
        }
        
        guard let url = URL(string: urlString) else {
            remove(receiver: receiver)
            container.status = .failed
            setToCache(container: container, for: key, notify: receiver)
            return
        }
        
        add(receiver: receiver, for: key)
        container.status = .inProgress
        setToCache(container: container, for: key, notify: receiver)
        downloadData(from: url, with: key)
    }
    
    func downloadData(from url: URL, with key: NSString) {
        let blockOperation = BlockOperation { [weak self] in
            guard let cachedContainer = self?.cache.object(forKey: key) else {
                self?.removeAllReceivers(for: key)
                return
            }
            
            let data = try? Data(contentsOf: url)
            self?.fillContainer(cachedContainer, with: data, urlString: String(key))
            self?.cache.setObject(cachedContainer, forKey: key)
            self?.notifyReceiver(for: key, with: cachedContainer)
            self?.removeAllReceivers(for: key)
        }
        
        queue.addOperation(blockOperation)
    }
    
    private func setToCache(container: ObjectContainer, for key: NSString, notify receiver: T) {
        cache.setObject(container, forKey: key)
        receiver.receive(objectWrapper: container.getStruct())
    }
    
    private func notifyReceiver(for key: NSString, with container: ObjectContainer) {
        let hashTable = waitingSenders[key]
        let receivers = hashTable?.allObjects as? [T]
        receivers?.forEach {
            $0.receive(objectWrapper: container.getStruct())
        }
    }
    
    private func removeAllReceivers(for key: NSString) {
        waitingSenders.removeValue(forKey: key)
    }
    
    private func remove(receiver: T) {
        guard let nsString = weakRecieverToWeakURL.object(forKey: receiver) else { return }
        
        weakRecieverToWeakURL.removeObject(forKey: receiver)
        let hashTable = waitingSenders[nsString]
        hashTable?.remove(receiver)
    }
    
    private func add(receiver: T, for key: NSString) {
        weakRecieverToWeakURL.setObject(key, forKey: receiver)
        
        let hashTable: NSHashTable<AnyObject>
        if let hTable = waitingSenders[key] {
            hashTable = hTable
        } else {
            hashTable = NSHashTable<AnyObject>.weakObjects()
            waitingSenders[key] = hashTable
        }
        
        hashTable.add(receiver)
    }
    
    private func fillContainer(_ container: ObjectContainer, with data: Data?, urlString: String) {
        guard let data = data else {
            container.status = .failed
            return
        }
        
        let obj = T.convertToObject(data, fromURL: urlString)
        container.object = obj
        container.status = .success
    }
}
