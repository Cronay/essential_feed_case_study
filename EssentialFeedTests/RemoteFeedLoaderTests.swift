//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Cronay on 07.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import XCTest

class RemoteFeedLoader {

}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()

        XCTAssertNil(client.requestedURL)
    }
}
