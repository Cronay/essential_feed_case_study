//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Cronay on 10.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }

    private static var OK_200: Int { return 200 }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.items
    }
}
