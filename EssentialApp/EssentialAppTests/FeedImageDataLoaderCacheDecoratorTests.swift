//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Cronay on 16.11.20.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader

    init(decoratee: FeedImageDataLoader) {
        self.decoratee = decoratee
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url, completion: completion)
    }
}

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {

    func test_loadImageData_deliversSuccessOnDecorateeSuccess() {
        let imageData = anyData()
        let (sut, loader) = makeSUT()

        expect(sut, toCompleteWith: .success(imageData), when: {
            loader.complete(with: imageData)
        })
    }

    func test_loadImageData_deliversErrorOnDecorateeFailure() {
        let (sut, loader) = makeSUT()

        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            loader.complete(with: anyNSError())
        })
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageDataLoaderCacheDecorator, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
}
