//
//  FeedImageCellController.swift
//  EssentialFeed
//
//  Created by Cronay on 12.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {

    private var delegate: FeedImageCellControllerDelegate
    private lazy var cell = FeedImageCell()

    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }

    func view() -> UITableViewCell {
        delegate.didRequestImage()
        return cell
    }

    func preload() {
        delegate.didRequestImage()
    }

    func cancelLoad() {
        delegate.didCancelImageRequest()
    }

    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.feedImageView.image = viewModel.image
        cell.feedImageContainer.isShimmering = viewModel.isLoading
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell.onRetry = delegate.didRequestImage
    }
}
