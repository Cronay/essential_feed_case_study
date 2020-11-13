//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialAppTests
//
//  Created by Cronay on 13.11.20.
//

import XCTest
import EssentialFeed

final class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    let primary: FeedImageDataLoader
    let fallback: FeedImageDataLoader

    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?

        func cancel() {
            wrapped?.cancel()
        }
    }

    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let taskWrapper = TaskWrapper()
        taskWrapper.wrapped = primary.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)

            case .failure:
                taskWrapper.wrapped = self?.fallback.loadImageData(from: url) { _ in }
            }
        }
        return taskWrapper
    }
}

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
        let exp = expectation(description: "Wait for load completion")

        _ = sut.loadImageData(from: anyURL(), completion: { result in
            switch result {
            case let .success(receivedData):
                XCTAssertEqual(data, receivedData)

            default:
                XCTFail("Expected success, got \(result) instead")
            }
            exp.fulfill()
        })

        primaryLoader.complete(with: data)

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImageDataLoader, primary: LoaderSpy, fallback: LoaderSpy) {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, primaryLoader, fallbackLoader)
    }

    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }

    private class LoaderSpy: FeedImageDataLoader {
        var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        var cancelledURLs = [URL]()

        var loadedURLs: [URL] {
            messages.map { $0.url }
        }

        private struct Task: FeedImageDataLoaderTask {
            let callback: () -> Void
            func cancel() { callback() }
        }

        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task { [weak self] in self?.cancelledURLs.append(url) }
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(with data: Data, at index: Int = 0) {
            messages[index].completion(.success(data))
        }
    }

    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any", code: 0)
    }

    private func anyData() -> Data {
        return Data("any data".utf8)
    }
}
