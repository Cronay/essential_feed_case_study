//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Cronay on 07.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedItemsMapperTests: XCTestCase {

    func test_map_deliversErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            let json = makeItemJSON([])
            XCTAssertThrowsError(try FeedItemsMapper.map(json, from: HTTPURLResponse(code: code)), "status code: \(code)")
        }
    }
    
    func test_map_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(code: 200)))
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemJSON([])
        
        let result = try FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(code: 200))
        
        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: UUID(),
                             imageURL: URL(string: "http://a-url.com")!)


        let item2 = makeItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageURL: URL(string: "http://another-url.com")!)

        let result = try FeedItemsMapper.map(makeItemJSON([item1.json, item2.json]), from: HTTPURLResponse(code: 200))

        XCTAssertEqual(result, [item1.model, item2.model])
    }

    // MARK: - Helpers

    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)

        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }

        return (item, json)
    }
}
