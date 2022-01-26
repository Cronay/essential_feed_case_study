//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 26.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public final class ImageCommentsMapper {
    private init() {}
    
    private struct Root: Decodable {
        let items: [RemoteImageCommentItem]
        
        var imageComments: [ImageComment] {
            items.map {
                ImageComment(id: $0.id, message: $0.message, createdAt: $0.created_at, author: $0.author.username)
            }
        }
    }
    
    private struct RemoteImageCommentItem: Decodable {
        let id: UUID
        let message: String
        let created_at: Date
        let author: RemoteImageCommentAuthor
    }

    private struct RemoteImageCommentAuthor: Decodable {
        let username: String
    }

    private static var OK_200: Int { return 200 }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        guard isOK(response), let root = try? jsonDecoder.decode(Root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.imageComments
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
