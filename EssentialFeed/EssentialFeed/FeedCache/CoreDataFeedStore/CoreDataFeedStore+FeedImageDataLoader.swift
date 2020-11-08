//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Cronay on 08.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        context.perform { [context] in
            guard let image = try? ManagedFeedImage.first(with: url, in: context) else { return }

            image.data = data
            try? context.save()
        }
    }

    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        context.perform { [context] in
            completion(Result {
                return try ManagedFeedImage.first(with: url, in: context)?.data
            })
        }
    }
}
