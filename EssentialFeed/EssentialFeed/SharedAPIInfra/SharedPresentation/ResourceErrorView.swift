//
//  ResourceErrorView.swift
//  EssentialFeed
//
//  Created by Yannic Borgfeld on 29.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import Foundation

public protocol ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel)
}
