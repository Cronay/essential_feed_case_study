//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Cronay on 16.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
