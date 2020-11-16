//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Cronay on 16.11.20.
//

import XCTest
import EssentialFeed

protocol FeedImageDataCache {
    typealias SaveResult = Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}

class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache

    init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.save(data, for: url) { _ in }
                return data
            })
        }
    }
}

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {

    func test_loadImageData_deliversSuccessOnDecorateeSuccess() {
        let imageData = anyData()
        let (sut, loader, _) = makeSUT()

        expect(sut, toCompleteWith: .success(imageData), when: {
            loader.complete(with: imageData)
        })
    }

    func test_loadImageData_deliversErrorOnDecorateeFailure() {
        let (sut, loader, _) = makeSUT()

        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            loader.complete(with: anyNSError())
        })
    }

    func test_loadImageData_cachesLoadedDataOnDecorateeSuccess() {
        let (sut, loader, cache) = makeSUT()
        let imageData = anyData()

        _ = sut.loadImageData(from: anyURL()) { _ in }
        loader.complete(with: imageData)

        XCTAssertEqual(cache.messages, [.save(imageData)])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageDataLoaderCacheDecorator, loader: FeedImageDataLoaderSpy, cache: CacheSpy) {
        let loader = FeedImageDataLoaderSpy()
        let cache = CacheSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(cache, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader, cache)
    }

    private class CacheSpy: FeedImageDataCache {
        enum Message: Equatable {
            case save(Data)
        }

        var messages = [Message]()

        func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(data))
            completion(.success(()))
        }
    }
}
