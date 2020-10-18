//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Cronay on 18.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
