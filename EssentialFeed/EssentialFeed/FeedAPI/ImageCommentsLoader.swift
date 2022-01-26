//
//  ImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 26.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public final class RemoteImageCommentsLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = Swift.Result<[ImageComment], Swift.Error>

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
                case let .success((data, response)):
                    completion(RemoteImageCommentsLoader.map(data, from: response))
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        Result {
            try ImageCommentsMapper.map(data, from: response)
        }
    }
}
