//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by Cronay on 08.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import CoreData

extension CoreDataFeedStore: FeedStore {
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        performAsync { context in
            completion(Result {
                try ManagedCache.deleteCache(in: context)
                try context.save()
            })
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        performAsync { context in
            completion(Result {
                let cache = try ManagedCache.getUniqueManagedCache(in: context)
                cache.timestamp = timestamp
                cache.images = feed.mapToManagedFeedImages(in: context)
                try context.save()
            })
        }
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        performAsync { context in
            completion(Result {
                try ManagedCache.fetchCache(in: context).map {
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            })
        }
    }
}

private extension Array where Element == LocalFeedImage {
    func mapToManagedFeedImages(in context: NSManagedObjectContext) -> NSOrderedSet {
        let managedFeedArray = self.map { (localImage) -> ManagedFeedImage in
            let managedFeedImage = ManagedFeedImage(context: context)

            managedFeedImage.id = localImage.id
            managedFeedImage.imageDescription = localImage.description
            managedFeedImage.location = localImage.location
            managedFeedImage.url = localImage.url
            managedFeedImage.data = context.userInfo[localImage.url] as? Data

            return managedFeedImage
        }
        context.userInfo.removeAllObjects()
        return NSOrderedSet(array: managedFeedArray)
    }
}

