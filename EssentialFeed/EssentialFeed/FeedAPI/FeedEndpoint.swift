//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 07.02.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            let url = baseURL.appendingPathComponent("/v1/feed")
            var components = URLComponents()
            components.scheme = url.scheme
            components.host = url.host
            components.path = url.path
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
            ]
            return components.url!
        }
    }
}
