//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Cronay on 06.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

public class LocalFeedImageDataLoader {

    private let store: FeedImageDataStore

    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader {
    public typealias SaveResult = Result<Void, Error>

    public func save(_ data: Data, for url: URL, completion: (SaveResult) -> Void) {
        store.insert(data, for: url) { _ in }
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    private class Task: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?

        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletion()
        }

        private func preventFurtherCompletion() {
            completion = nil
        }
    }

    public enum Error: Swift.Error {
        case failed
        case notFound
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = Task(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                            .mapError { _ in Error.failed }
                            .flatMap { data in
                                data.map { .success($0) } ?? .failure(Error.notFound)
                            })
        }
        return task
    }
}
