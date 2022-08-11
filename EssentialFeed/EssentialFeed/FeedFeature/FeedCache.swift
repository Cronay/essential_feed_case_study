//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Cronay on 15.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    @available(*, deprecated)
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
    
    func save(_ feed: [FeedImage]) throws
}

public extension FeedCache {
    func save(_ feed: [FeedImage]) throws {
        let group = DispatchGroup()
        group.enter()
        var result: Result!
        save(feed) { capturedResult in
            result = capturedResult
            group.leave()
        }
        
        return try result.get()
    }
}
