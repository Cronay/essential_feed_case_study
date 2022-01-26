//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Cronay on 10.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

final public class FeedItemsMapper {
    private init() {}
    
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
        
        var feedImages: [FeedImage] {
            items.map {
                FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image)
            }
        }
    }
    
    private struct RemoteFeedItem: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
    }

    private static var OK_200: Int { return 200 }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.feedImages
    }
}
