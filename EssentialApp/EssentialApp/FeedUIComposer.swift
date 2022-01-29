//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Cronay on 12.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(
            feedLoader: { feedLoader().dispatchOnMainQueue() }
        )

        let feedController = FeedViewController.makeWith(
            delegate: presentationAdapter,
            title: FeedPresenter.title)
        
        let presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: { imageLoader($0).dispatchOnMainQueue() }
            ),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map
        )

        presentationAdapter.presenter = presenter
        return feedController
    }
}

private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = FeedPresenter.title
        return feedController
    }
}
