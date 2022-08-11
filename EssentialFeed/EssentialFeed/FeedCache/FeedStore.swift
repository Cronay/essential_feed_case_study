//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Cronay on 29.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void

    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void

    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @available(*, deprecated)
    func deleteCachedFeed(completion: @escaping DeletionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @available(*, deprecated)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @available(*, deprecated)
    func retrieve(completion: @escaping RetrievalCompletion)
    
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}

public extension FeedStore {
    func deleteCachedFeed() throws {
        let group = DispatchGroup()
    
        group.enter()
        var result: Result<Void, Error>!
        deleteCachedFeed { capturedResult in
            result = capturedResult
            group.leave()
        }
        
        group.wait()
        try result.get()
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        let group = DispatchGroup()
    
        group.enter()
        var result: Result<Void, Error>!
        insert(feed, timestamp: timestamp) { capturedResult in
            result = capturedResult
            group.leave()
        }
        
        group.wait()
        try result.get()
    }
    
    func retrieve() throws -> CachedFeed? {
        let group = DispatchGroup()
    
        group.enter()
        var result: Result<CachedFeed?, Error>!
        retrieve { capturedResult in
            result = capturedResult
            group.leave()
        }
        
        group.wait()
        return try result.get()
    }

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {}
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {}
    func retrieve(completion: @escaping RetrievalCompletion) {}
}
