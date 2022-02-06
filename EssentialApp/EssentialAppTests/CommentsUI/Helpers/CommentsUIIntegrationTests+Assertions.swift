//
//  CommentsUIIntegrationTests+Assertions.swift
//  EssentialAppTests
//
//  Created by Yannic Borgfeld on 06.02.22.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

extension CommentsUIIntegrationTests {
    func assertThat(_ sut: ListViewController, isRendering comments: [ImageComment], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedCommentViews() == comments.count else {
            return XCTFail("Expected \(comments.count) comments, got \(sut.numberOfRenderedCommentViews()) instead", file: file, line: line)
        }
        
        let viewModel = ImageCommentsPresenter.map(comments)
        
        viewModel.comments.enumerated().forEach { index, comment in
            XCTAssertEqual(sut.commentMessage(at: index), comment.message, "message at \(index)", file: file, line: line)
            XCTAssertEqual(sut.commentDate(at: index), comment.createdAt, "date at \(index)", file: file, line: line)
            XCTAssertEqual(sut.commentAuthor(at: index), comment.author, "author at \(index)", file: file, line: line)
        }
    }
}
