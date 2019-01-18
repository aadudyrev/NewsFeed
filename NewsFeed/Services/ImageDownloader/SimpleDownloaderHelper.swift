//
//  SimpleDownloaderHelper.swift
//  NewsFeed
//
//  Created by Admin on 15/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

class ObjectContainer {
    var object: AnyObject? = nil
    var status: ObjectWrapper.Status = .noDownload
    
    func getStruct() -> ObjectWrapper {
        let item = ObjectWrapper(status: status, object: object)
        return item
    }
}

struct ObjectWrapper {

    enum Status {
        case noDownload
        case inProgress
        case success
        case failed
    }

    let status: Status
    let object: AnyObject?
}

protocol PendingAnObject: class {
    static func convertToObject(_ data: Data, fromURL: String) -> AnyObject?
    func receive(objectWrapper: ObjectWrapper)
}
