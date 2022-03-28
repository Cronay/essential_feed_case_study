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
        numberOfRows(in: commentsSection)
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
        cell(row: row, section: commentsSection) as? ImageCommentCell
    }

}
