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
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
