//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Cronay on 06.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>

    typealias InsertionResult = Swift.Result<Void, Error>

    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
    
    @available(*, deprecated)
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    @available(*, deprecated)
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}

public extension FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws {
        let group = DispatchGroup()
        group.enter()
        
        var result: Result<Void, Error>!
        insert(data, for: url) { capturedResult in
            result = capturedResult
            group.leave()
        }
        
        group.wait()
        
        return try result.get()
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        let group = DispatchGroup()
        group.enter()
        
        var result: Result<Data?, Error>!
        retrieve(dataForURL: url) { capturedResult in
            result = capturedResult
            group.leave()
        }
        
        group.wait()
        
        return try result.get()
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {}
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {}
}
