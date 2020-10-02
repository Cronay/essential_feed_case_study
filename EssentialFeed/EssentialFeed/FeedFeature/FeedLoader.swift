//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Cronay on 07.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
