//
//  CacheFeedUseCase.swift
//  EssentialFeedTests
//
//  Created by Cronay on 27.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {

    }
}

class FeedStore {
    var deleteCacheFeedCallCount = 0
}

class CacheFeedUseCase: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)

        XCTAssertEqual(store.deleteCacheFeedCallCount, 0)
    }
}
