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
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy {
        let messages = [Any]()
    }
}
