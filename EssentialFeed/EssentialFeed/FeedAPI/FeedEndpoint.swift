//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 07.02.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public enum FeedEndpoint {
    case get(after: FeedImage? = nil)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(after):
            let url = baseURL.appendingPathComponent("/v1/feed")
            var components = URLComponents()
            components.scheme = url.scheme
            components.host = url.host
            components.path = url.path
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10"),
                after.map { URLQueryItem(name: "after_id", value: $0.id.uuidString) }
            ].compactMap { $0 }
            return components.url!
        }
    }
}
