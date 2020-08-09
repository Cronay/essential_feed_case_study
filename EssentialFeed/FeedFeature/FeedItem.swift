//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Cronay on 07.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public struct FeedItem: Equatable {
    let ui: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
