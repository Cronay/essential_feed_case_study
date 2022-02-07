//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 07.02.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/image/\(id.uuidString)/comments")
        }
    }
}
