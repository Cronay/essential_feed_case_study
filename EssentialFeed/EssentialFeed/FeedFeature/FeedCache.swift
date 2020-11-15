//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Cronay on 15.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
