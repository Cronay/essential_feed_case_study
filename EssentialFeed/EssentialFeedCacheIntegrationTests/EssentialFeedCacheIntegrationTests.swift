//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Cronay on 01.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import XCTest
import EssentialFeed

class EssentialFeedCacheIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()

        setUpEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()

        undoStoreSideEffects()
    }

    // MARK: - LocalFeedLoader Tests

    func test_loadFeed_deliversEmptyFromEmptyCache() {
        let sut = makeFeedLoader()

        expect(sut, toLoad: [])
    }

    func test_loadFeed_deliversItemsSavedOnASeparateInstance() {
        let feedLoaderToPerformSave = makeFeedLoader()
        let feedLoaderToPerformLoad = makeFeedLoader()
        let feed = uniqueImageFeed().models

        save(feed, with: feedLoaderToPerformSave)

        expect(feedLoaderToPerformLoad, toLoad: feed)
    }

    func test_saveFeed_overridesItemsSavedOnAnotherInstance() {
        let feedLoaderToPerformFirstSave = makeFeedLoader()
        let feedLoaderToPerformLastSave = makeFeedLoader()
        let feedLoaderToPerformLoad = makeFeedLoader()
        let firstFeed = uniqueImageFeed().models
        let latestFeed = uniqueImageFeed().models

        save(firstFeed, with: feedLoaderToPerformFirstSave)
        save(latestFeed, with: feedLoaderToPerformLastSave)

        expect(feedLoaderToPerformLoad, toLoad: latestFeed)
    }

    func test_validateFeedCache_doesNotDeleteRecentlySavedFeed() {
        let feedLoaderToPerformSave = makeFeedLoader()
        let feedLoaderToPerformValidation = makeFeedLoader()
        let feed = uniqueImageFeed().models

        save(feed, with: feedLoaderToPerformSave)
        validateCache(with: feedLoaderToPerformValidation)

        expect(feedLoaderToPerformSave, toLoad: feed)
    }

    // MARK: - LocalFeedImageDataLoader Tests

    func test_loadImageData_deliversSavedDataOnASeparateInstance() {
        let imageLoaderToSave = makeImageLoader()
        let imageLoaderToLoad = makeImageLoader()
        let feedLoader = makeFeedLoader()
        let image = uniqueImage()
        let dataToSave = anyData()

        save([image], with: feedLoader)
        save(dataToSave, for: image.url, with: imageLoaderToSave)

        expect(imageLoaderToLoad, toLoad: dataToSave, for: image.url)
    }

    func test_saveImageData_overridesSavedImageDataOnASeparateInstance() {
        let firstImageLoaderToSave = makeImageLoader()
        let secondImageLoaderToSave = makeImageLoader()
        let imageLoaderToLoad = makeImageLoader()
        let feedLoader = makeFeedLoader()
        let image = uniqueImage()
        let firstDataToSave = Data("first".utf8)
        let secondDataToSave = Data("second".utf8)

        save([image], with: feedLoader)
        save(firstDataToSave, for: image.url, with: firstImageLoaderToSave)
        save(secondDataToSave, for: image.url, with: secondImageLoaderToSave)

        expect(imageLoaderToLoad, toLoad: secondDataToSave, for: image.url)
    }


    // MARK: - Helpers

    private func makeFeedLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalFeedLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func makeImageLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalFeedImageDataLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut

    }

    private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedImage], file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(loadedFeed):
                XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)
            case let .failure(error):
                XCTFail("Expected result was success with empty cache, got \(error) instead", file: file, line: line)
            }

            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func expect(_ sut: LocalFeedImageDataLoader, toLoad expectedData: Data, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        _ = sut.loadImageData(from: url) { result in
            switch result {
            case let .success(receivedData):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            case let .failure(error):
                XCTFail("Expected result was success, got \(error) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func save(_ feed: [FeedImage], with loader: LocalFeedLoader, file: StaticString = #filePath, line: UInt = #line) {
        let saveExp = expectation(description: "Wait for save completion")
        loader.save(feed) { result in
            if case Result.failure(_) = result {
                XCTFail("Expected to save feed successfully", file: file, line: line)
            }
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
    }

    private func save(_ data: Data, for url: URL, with imageLoader: LocalFeedImageDataLoader, file: StaticString = #filePath, line: UInt = #line) {
        let saveExp = expectation(description: "Wait for save completion")
        imageLoader.save(data, for: url) { result in
            if case Result.failure(_) = result {
                XCTFail("Expected to save feed image successfully", file: file, line: line)
            }
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
    }

    private func validateCache(with loader: LocalFeedLoader, file: StaticString = #file, line: UInt = #line) {
        let saveExp = expectation(description: "Wait for save completion")
        loader.validateCache() { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to validate feed successfully, got error: \(error)", file: file, line: line)
            }
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
    }

    private func setUpEmptyStoreState() {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }

    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
