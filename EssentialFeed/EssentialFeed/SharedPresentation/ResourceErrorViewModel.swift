//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 29.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?

    public static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }

    public static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
