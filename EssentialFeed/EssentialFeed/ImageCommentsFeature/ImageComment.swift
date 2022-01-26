//
//  ImageComment.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 26.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public struct ImageComment: Equatable {
    public let id: UUID
    public let message: String
    public let createdAt: Date
    public let author: String
    
    public init(id: UUID, message: String, createdAt: Date, author: String) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
        self.author = author
    }
}
