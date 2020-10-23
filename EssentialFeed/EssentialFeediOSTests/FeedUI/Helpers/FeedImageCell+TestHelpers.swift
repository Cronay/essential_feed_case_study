//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Cronay on 23.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell {
    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }

    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }

    var isShowingImageLoadingIndicator: Bool {
        return feedImageContainer.isShimmering
    }

    var locationText: String? {
        return locationLabel.text
    }

    var descriptionText: String? {
        return descriptionLabel.text
    }

    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }

    var isShowingRetryAction: Bool {
        return !feedImageRetryButton.isHidden
    }
}
