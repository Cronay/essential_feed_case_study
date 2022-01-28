//
//  ImageCommentsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Yannic Borgfeld on 26.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {

    func test_load_deliversErrorOnNon2xxHTTPResponse() throws {
        let samples = [199, 300, 301, 400, 500]

        try samples.forEach { code in
            let json = makeItemJSON([])
            XCTAssertThrowsError(try ImageCommentsMapper.map(json, from: HTTPURLResponse(code: code)))
        }
    }

    func test_load_deliversErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let samples = [200, 201, 204, 250, 299]
        
        try samples.forEach { code in
            let invalidJSON = Data("invalid json".utf8)
            XCTAssertThrowsError(try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(code: code)))
        }
    }

    func test_load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let samples = [200, 201, 204, 250, 299]
        let emptyListJSON = makeItemJSON([])
        
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(code: code))
            XCTAssertEqual(result, [])
        }
    }

    func test_load_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: UUID(),
                             message: "a message",
                             createdAt: (date: Date(timeIntervalSince1970: 1589973899), iso8601String: "2020-05-20T11:24:59+00:00"),
                             author: "an author")


        let item2 = makeItem(id: UUID(),
                             message: "aother message",
                             createdAt: (date: Date(timeIntervalSince1970: 1589898233), iso8601String: "2020-05-19T14:23:53+00:00"),
                             author: "another author")

        let items = [item1.model, item2.model]
        let json = makeItemJSON([item1.json, item2.json])

        let samples = [200, 201, 204, 250, 299]

        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(code: code))
            XCTAssertEqual(result, items)
        }
    }

    // MARK: - Helpers

    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), author: String) -> (model: ImageComment, json: [String: Any]) {
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, author: author)

        let json: [String: Any] = [
            "id": id.uuidString,
            "message": message,
            "created_at": createdAt.iso8601String,
            "author": [
                "username": author
            ]
        ]

        return (item, json)
    }
}
