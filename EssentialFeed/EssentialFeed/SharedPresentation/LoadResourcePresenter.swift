//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 28.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
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


public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    
    private let resourceView: View
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    private let mapper: Mapper

    public static var loadError: String {
        return NSLocalizedString("GENERIC_CONNECTION_ERROR",
                                 tableName: "Shared",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the resource from the server")
    }

    public init(resourceView: View,
                loadingView: ResourceLoadingView,
                errorView: ResourceErrorView,
                mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }

    public func didStartLoading() {
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
        errorView.display(.noError)
    }

    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }

    public func didFinishLoading(with error: Error) {
        errorView.display(.error(message: Self.loadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
