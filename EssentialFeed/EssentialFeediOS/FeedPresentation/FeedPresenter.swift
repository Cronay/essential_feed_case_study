//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Cronay on 18.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var feedView: FeedView?
    var feedLoadingView: FeedLoadingView?

    func loadFeed() {
        feedLoadingView?.display(isLoading: true)
        feedLoader.load() { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.feedLoadingView?.display(isLoading: false)
        }
    }
}

