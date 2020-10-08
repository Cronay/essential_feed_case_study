//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Cronay on 08.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import XCTest

final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
}

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)

        XCTAssertEqual(loader.loaderCallCount, 0)
    }

    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
