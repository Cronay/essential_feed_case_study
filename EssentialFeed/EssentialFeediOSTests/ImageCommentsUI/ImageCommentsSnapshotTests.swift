//
//  ImageCommentsSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Yannic Borgfeld on 05.02.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

class ImageCommentsSnapshotTests: XCTestCase, SnapshotTestCase {
    
    func test_listWithComments() {
        let sut = makeSUT()

        sut.display(comments())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LIST_WITH_COMMENTS_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LIST_WITH_COMMENTS_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func comments() -> [CellController] {
        return [
            ImageCommentCellController(model: ImageCommentViewModel(
                message: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                createdAt: "1000 years ago",
                author: "a long long long long username"
            )),
            ImageCommentCellController(model: ImageCommentViewModel(
                message: "The East Side Gallery is an open-air gallery in Berlin.",
                createdAt: "10 days ago",
                author: "some username"
            )),
            ImageCommentCellController(model: ImageCommentViewModel(
                message: "nice",
                createdAt: "1 hour ago",
                author: "a."
            ))
        ]
    }
}
