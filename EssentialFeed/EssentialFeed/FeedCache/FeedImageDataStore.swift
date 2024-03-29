//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Cronay on 06.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
