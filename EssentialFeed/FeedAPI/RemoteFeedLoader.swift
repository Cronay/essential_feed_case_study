//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Cronay on 08.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
                case let .success(data, _):
                    if let json = try? JSONSerialization.jsonObject(with: data) {
                        completion(.success([]))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case .failure:
                    completion(.failure(.connectivity))
            }
        }
    }
}
