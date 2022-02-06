//
//  ListViewController+CommentsTestHelpers.swift
//  EssentialAppTests
//
//  Created by Yannic Borgfeld on 06.02.22.
//

import UIKit
import EssentialFeediOS

extension ListViewController {
    private var commentsSection: Int {
        return 0
    }
    
    func numberOfRenderedCommentViews() -> Int {
        tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: commentsSection)
    }
    
    func commentMessage(at row: Int) -> String? {
        let view = commentView(at: row)
        return view?.messageLabel.text
    }
    
    func commentDate(at row: Int) -> String? {
        let view = commentView(at: row)
        return view?.dateLabel.text
    }
    
    func commentAuthor(at row: Int) -> String? {
        let view = commentView(at: row)
        return view?.authorLabel.text
    }

    private func commentView(at row: Int) -> ImageCommentCell? {
        guard numberOfRenderedFeedImageViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: commentsSection)
        return ds?.tableView(tableView, cellForRowAt: index) as? ImageCommentCell
    }

}
