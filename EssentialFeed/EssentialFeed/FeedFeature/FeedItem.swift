//
//  FeedImage.swift
//  EssentialFeed
//
//  Created by Cronay on 07.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public struct FeedImage: Equatable, Hashable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL

    public init(id :UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
