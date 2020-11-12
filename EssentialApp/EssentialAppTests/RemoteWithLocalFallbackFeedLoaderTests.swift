//
//  RemoteWithLocalFallbackFeedLoaderTests.swift
//  EssentialAppTests
//
//  Created by Cronay on 12.11.20.
//

import XCTest
import EssentialFeed

class FeedLoaderWithFallbackComposite: FeedLoader {
    init(primary: FeedLoader, fallback: FeedLoader) {

    }
}

class FeedLoaderWithFallbackCompositeTests: XCTestCase {

    func test_load_deliversRemoteFeedOnRemoteSuccess() {
        let primaryStub = LoaderStub()
        let fallbackStub = LoaderStub()
        let sut = FeedLoaderWithFallbackComposite(primary: primaryStub, fallback: fallbackStub)

        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(receivedFeed):
                XCTAssertEqual(remoteFeed, receivedFeed)

            case .failure:
                XCTFail("Expected successful load feed result, got \(result) instead")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    private class LoaderStub: FeedLoader {
        func load(completion: @escaping (FeedLoader.Result) -> Void) {

        }
    }
}
