//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 26.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

class ImageCommentsMapper {
    private struct Root: Decodable {
        let items: [RemoteImageCommentItem]
    }

    private static var OK_200: Int { return 200 }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteImageCommentItem] {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        guard isOK(response), let root = try? jsonDecoder.decode(Root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.items
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
