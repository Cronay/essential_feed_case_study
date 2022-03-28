//
//  CommentsViewAdapter.swift
//  EssentialApp
//
//  Created by Yannic Borgfeld on 06.02.22.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

final class CommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?

    init(controller: ListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            return CellController(id: viewModel, ImageCommentCellController(model: viewModel))
        })
    }
}
