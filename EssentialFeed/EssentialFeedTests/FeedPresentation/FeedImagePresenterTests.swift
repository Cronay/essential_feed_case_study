//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Cronay on 31.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import XCTest

class FeedImagePresenter {

    init(view: Any) {

    }
}

class FeedImagePresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        _ = FeedImagePresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty)
    }

    // MARK: - Helpers

    private class ViewSpy {
        let messages = [Any]()
    }
}
