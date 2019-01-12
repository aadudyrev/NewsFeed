//
//  Error.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import Foundation

struct NewsError: ItSelfDecodable {
    let status: String?
    let code: String?
    let message: String?
}
