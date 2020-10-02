//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Cronay on 30.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
