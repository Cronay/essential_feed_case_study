//
//  RemoteImageCommentItem.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 26.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

struct RemoteImageCommentItem: Decodable {
    let id: UUID
    let message: String
    let created_at: Date
    let author: RemoteImageCommentAuthor
}

struct RemoteImageCommentAuthor: Decodable {
    let username: String
}
