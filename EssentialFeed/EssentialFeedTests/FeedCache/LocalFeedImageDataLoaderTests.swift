//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Cronay on 06.11.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import XCTest
import EssentialFeed

protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}

class LocalFeedImageDataLoader: FeedImageDataLoader {

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

    let store: FeedImageDataStore

    init(store: FeedImageDataStore) {
        self.store = store
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
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

class LocalFeedImageDataLoaderTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()

        _ = sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(store.requestedURLs, [url])
    }

    func test_loadImageDataFromURL_deliversErrorOnStoreError() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: failed(), when: {
            let retrievalError = anyNSError()
            store.complete(with: retrievalError)
        })
    }

    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: notFound(), when: {
            store.complete(with: .none)
        })
    }

    func test_loadImageDataFromURL_deliversDataOnFoundData() {
        let (sut, store) = makeSUT()
        let foundData = anyData()

        expect(sut, toCompleteWith: .success(foundData), when: {
            store.complete(with: foundData)
        })
    }

    func test_loadImageDataFromURL_doesNotDeliverResultAfterTaskHasBeenCancelled() {
        let (sut, store) = makeSUT()
        let foundData = anyData()

        var receivedResults = [FeedImageDataLoader.Result]()
        let task = sut.loadImageData(from: anyURL()) { receivedResults.append($0) }
        task.cancel()

        store.complete(with: foundData)
        store.complete(with: .none)
        store.complete(with: anyNSError())

        XCTAssertTrue(receivedResults.isEmpty, "Expected no received results after cancelling task")
    }

    func test_loadImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = StoreSpy()
        var sut: LocalFeedImageDataLoader? = LocalFeedImageDataLoader(store: store)

        var receivedResults = [FeedImageDataLoader.Result]()
        _ = sut!.loadImageData(from: anyURL()) { receivedResults.append($0) }

        sut = nil
        store.complete(with: anyNSError())

        XCTAssertTrue(receivedResults.isEmpty, "Expected no result after instance has been deallocated")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        _ = sut.loadImageData(from: anyURL(), completion: { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.failure(expectedError as LocalFeedImageDataLoader.Error), .failure(receivedError as LocalFeedImageDataLoader.Error)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)

            case let (.success(expectedData), .success(receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult), received \(receivedResult)", file: file, line: line)
            }
            exp.fulfill()
        })

        action()

        wait(for: [exp], timeout: 1.0)
    }

    private func failed() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.failed)
    }

    private func notFound() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.notFound)
    }

    private class StoreSpy: FeedImageDataStore {
        var receivedMessages = [(url: URL, completion: (FeedImageDataStore.Result) -> Void)]()

        var requestedURLs: [URL] {
            return receivedMessages.map { $0.url }
        }

        func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
            receivedMessages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            receivedMessages[index].completion(.failure(error))
        }

        func complete(with data: Data?, at index: Int = 0) {
            receivedMessages[index].completion(.success(data))
        }
    }
}
