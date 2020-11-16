//
//  FeedImageDataLoaderTestCase.swift
//  EssentialAppTests
//
//  Created by Cronay on 16.11.20.
//

import XCTest
import EssentialFeed

protocol FeedImageDataLoaderTestCase: XCTestCase {}

extension FeedImageDataLoaderTestCase {
    func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        _ = sut.loadImageData(from: anyURL(), completion: { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(expectedData), .success(receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)

            case (.failure, .failure):
                break

            default:
                XCTFail("Expected success, got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        })

        action()

        wait(for: [exp], timeout: 1.0)
    }

}
