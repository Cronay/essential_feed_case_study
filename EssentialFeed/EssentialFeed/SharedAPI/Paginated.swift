//
//  Paginated.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 28.03.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public struct Paginated<Item> {
    public typealias LoadMoreCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    public let loadMore: ((@escaping LoadMoreCompletion) -> Void)?
    
    public init(items: [Item], loadMore: ((@escaping LoadMoreCompletion) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}
