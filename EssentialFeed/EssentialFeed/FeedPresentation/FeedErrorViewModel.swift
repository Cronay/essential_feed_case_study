//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Cronay on 31.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

public struct FeedErrorViewModel {
    public let message: String?

    public static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    public static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
