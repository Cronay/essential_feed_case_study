//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Cronay on 27.09.20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataFeedStore {

    private let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext

    public init(storeURL: URL) throws {
        guard let managedObjectModel = NSManagedObjectModel.model else {
            throw NSError(domain: "Couldn't load managed object model", code: 0)
        }

        persistentContainer = try NSPersistentContainer.loadFeedStorePersistentContainer(at: storeURL, with: managedObjectModel)
        context = persistentContainer.newBackgroundContext()
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
