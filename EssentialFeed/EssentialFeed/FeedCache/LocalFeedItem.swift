//
//  LocalFeedImage.swift
//  EssentialFeed
//
//  Created by Cronay on 30.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public struct LocalFeedImage: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL

    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
