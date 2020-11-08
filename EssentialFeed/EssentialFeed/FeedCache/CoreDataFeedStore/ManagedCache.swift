//
//  ManagedCache+CoreDataProperties.swift
//  FeedStoreChallenge
//
//  Created by Cronay on 28.09.20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {

    @nonobjc class func fetchCache(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: "Cache")
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }

    @NSManaged var timestamp: Date
    @NSManaged var images: NSOrderedSet

    static func getUniqueManagedCache(in context: NSManagedObjectContext) -> ManagedCache {
        if let fetchedCache = try? fetchCache(in: context) {
            context.delete(fetchedCache)
        }

        return ManagedCache(context: context)
    }

    var localFeed: [LocalFeedImage] {
        return images.compactMap { (managedImage) -> LocalFeedImage? in
            if let image = managedImage as? ManagedFeedImage {
                return image.localFeedImage
            } else {
                return nil
            }
        }
    }
}
