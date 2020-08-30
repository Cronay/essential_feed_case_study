//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Cronay on 29.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
}
