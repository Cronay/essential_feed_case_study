//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Cronay on 31.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    public var hasLocation: Bool {
        return location != nil
    }
}
