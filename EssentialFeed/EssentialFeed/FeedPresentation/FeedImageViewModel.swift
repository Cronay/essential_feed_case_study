//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Cronay on 31.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool

    public var hasLocation: Bool {
        return location != nil
    }
}
