//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Cronay on 27.09.20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {

    private let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext

    public init(storeURL: URL) throws {
        guard let managedObjectModel = NSManagedObjectModel.model else {
            throw NSError(domain: "Couldn't load managed object model", code: 0)
        }

        persistentContainer = try NSPersistentContainer.loadFeedStorePersistentContainer(at: storeURL, with: managedObjectModel)
        context = persistentContainer.newBackgroundContext()
    }

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
                    return CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            })
        }
    }
}

private extension NSManagedObjectModel {
    static let model: NSManagedObjectModel? = {
        guard let modelURL = Bundle(for: CoreDataFeedStore.self).url(forResource: "FeedCache", withExtension: "momd") else {
            return nil
        }

        return NSManagedObjectModel(contentsOf: modelURL)
    }()
}

private extension NSPersistentContainer {
    static func loadFeedStorePersistentContainer(at storeURL: URL, with managedObjectModel: NSManagedObjectModel) throws -> NSPersistentContainer {
        let persistentContainer = NSPersistentContainer(name: "FeedCache", managedObjectModel: managedObjectModel)
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        persistentContainer.persistentStoreDescriptions = [storeDescription]

        var receivedError: Error?
        persistentContainer.loadPersistentStores { (_, error) in
            receivedError = error
        }
        if let error = receivedError { throw error }

        return persistentContainer
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
