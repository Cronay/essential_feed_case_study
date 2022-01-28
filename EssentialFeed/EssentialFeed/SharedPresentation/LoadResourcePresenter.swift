//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 28.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol ResourceView {
    func display(_ viewModel: String)
}

public struct ResourceLoadingViewModel {
    public let isLoading: Bool
}

public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}

public protocol ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel)
}

public struct ResourceErrorViewModel {
    public let message: String?

    public static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }

    public static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}


public final class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    
    private let resourceView: ResourceView
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    private let mapper: Mapper

    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(feedView: ResourceView,
                loadingView: ResourceLoadingView,
                errorView: ResourceErrorView,
                mapper: @escaping Mapper) {
        self.resourceView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }

    public func didStartLoading() {
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
        errorView.display(.noError)
    }

    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }

    public func didFinishLoading(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
