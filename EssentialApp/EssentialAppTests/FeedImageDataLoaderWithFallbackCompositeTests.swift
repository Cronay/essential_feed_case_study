//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialAppTests
//
//  Created by Cronay on 13.11.20.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

    func test_init_doesNotLoadImageData() {
        let (_, primaryLoader, fallbackLoader) = makeSUT()
        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }

    func test_loadImageData_fromPrimaryFirst() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let url = anyURL()

        _ = sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected one URL to be loaded from primary")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URL from fallback")
    }

    func test_loadImageData_loadsFromFallbackWhenPrimaryFails() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let url = anyURL()

        _ = sut.loadImageData(from: url) { _ in }
        primaryLoader.complete(with: anyNSError())

        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected one URL to be loaded from primary")
        XCTAssertEqual(fallbackLoader.loadedURLs, [url], "Expected one URL to be loaded from fallback")
    }

    func test_loadImageData_cancelsPrimaryLoaderTaskOnCancel() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let url = anyURL()

        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()

        XCTAssertEqual(primaryLoader.cancelledURLs, [url], "Expected one URL to be cancelled from primary")
        XCTAssertTrue(fallbackLoader.cancelledURLs.isEmpty, "Expected no cancelled URLs from fallback")
    }

    func test_loadImageData_cancelsFallbackLoaderAfterPrimaryLoaderFailed() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()
        let url = anyURL()

        let task = sut.loadImageData(from: url) { _ in }
        primaryLoader.complete(with: anyNSError())
        task.cancel()

        XCTAssertTrue(primaryLoader.cancelledURLs.isEmpty, "Expected no cancelled URL for the primary")
        XCTAssertEqual(fallbackLoader.cancelledURLs, [url], "Expected URL to be cancelled for the fallback")
    }

    func test_loadImageData_deliversPrimaryDataOnPrimarySuccess() {
        let data = anyData()
        let (sut, primaryLoader, _) = makeSUT()

        expect(sut, toCompleteWith: .success(data), when: {
            primaryLoader.complete(with: data)
        })
    }

    func test_loadImageData_deliversFallbackDataOnFallbackSuccess() {
        let data = anyData()
        let (sut, primaryLoader, fallBackLoader) = makeSUT()

        expect(sut, toCompleteWith: .success(data), when: {
            primaryLoader.complete(with: anyNSError())
            fallBackLoader.complete(with: data)
        })
    }

    func test_loadImageData_deliversErrorOnBothPrimaryAndFallbackFailure() {
        let (sut, primaryLoader, fallBackLoader) = makeSUT()

        expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            primaryLoader.complete(with: anyNSError())
            fallBackLoader.complete(with: anyNSError())
        })
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageDataLoader, primary: FeedImageDataLoaderSpy, fallback: FeedImageDataLoaderSpy) {
        let primaryLoader = FeedImageDataLoaderSpy()
        let fallbackLoader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, primaryLoader, fallbackLoader)
    }

    private func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        _ = sut.loadImageData(from: anyURL(), completion: { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(expectedData), .success(receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)

            case (.failure, .failure):
                break

            default:
                XCTFail("Expected success, got \(receivedResult) instead")
            }
            exp.fulfill()
        })

        action()

        wait(for: [exp], timeout: 1.0)

    }
}
