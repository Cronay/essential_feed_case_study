//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Cronay on 31.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
