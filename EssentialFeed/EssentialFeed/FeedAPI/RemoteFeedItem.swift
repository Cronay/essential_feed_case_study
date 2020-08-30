//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Cronay on 30.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
