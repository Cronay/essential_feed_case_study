//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Cronay on 15.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}

