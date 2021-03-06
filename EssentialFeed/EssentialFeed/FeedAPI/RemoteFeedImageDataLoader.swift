//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Cronay on 05.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public final class RemoteFeedImageDataLoader: FeedImageDataLoader {
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case invalidData
        case connectivity
    }

    public init(client: HTTPClient) {
        self.client = client
    }

    private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?

        var wrapped: HTTPClientTask?

        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletion()
            wrapped?.cancel()
        }

        private func preventFurtherCompletion() {
            completion = nil
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                            .mapError { _ in Error.connectivity }
                            .flatMap { (data, response) in
                                let isValidResponse = response.isOK && !data.isEmpty
                                return isValidResponse ? .success(data) : .failure(Error.invalidData)
                            })
        }

        return task
    }
}
