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
        context.perform { [context] in
            completion(Result {
                try ManagedCache.fetchCache(in: context).map(context.delete).map(context.save)
            })
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        context.perform { [context] in
            completion(Result {
                let cache = ManagedCache.getUniqueManagedCache(in: context)
                cache.timestamp = timestamp
                cache.images = feed.mapToManagedFeedImages(in: context)
                try context.save()
            })
        }
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        context.perform { [context] in
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

            return managedFeedImage
        }

        return NSOrderedSet(array: managedFeedArray)
    }
}

