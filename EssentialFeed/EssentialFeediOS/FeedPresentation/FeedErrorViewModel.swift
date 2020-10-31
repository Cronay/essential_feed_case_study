//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Cronay on 31.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

struct FeedErrorViewModel {
    let message: String?

    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
