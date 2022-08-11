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
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
