//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Cronay on 13.11.20.
//

import Foundation
import EssentialFeed

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
}

var commentsTitle: String {
    ImageCommentsPresenter.title
}

var feedTitle: String {
    FeedPresenter.title
}

var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}

private class DummyView: ResourceView {
    func display(_ viewModel: Any) {}
}


