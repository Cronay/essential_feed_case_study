//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Cronay on 16.09.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

final class FeedCachePolicy {
    private init() {}

    static private let calendar = Calendar(identifier: .gregorian)

    static private var maxCacheAgeInDays: Int {
        return 7
    }

    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
