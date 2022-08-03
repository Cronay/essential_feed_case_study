//
//  FeedAcceptanceTests.swift
//  EssentialAppTests
//
//  Created by Cronay on 22.11.20.
//

import XCTest
import EssentialFeed
import EssentialFeediOS
@testable import EssentialApp

class FeedAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(response), store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertTrue(feed.canLoadMore)

        feed.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), makeImageData2())
        XCTAssertTrue(feed.canLoadMore)
        
        feed.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), makeImageData2())
        XCTAssertFalse(feed.canLoadMore)
    }

    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)
        onlineFeed.simulateLoadMoreFeedAction()
        onlineFeed.simulateFeedImageViewVisible(at: 2)

        let offlineFeed = launch(httpClient: .offline, store: sharedStore)

        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 2), makeImageData2())
    }

    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 0)
    }

    func test_onEnteringBackground_deletesExpiredFeedCache() {
        let store = InMemoryFeedStore.withExpiredFeedCache

        enterBackground(with: store)

        XCTAssertNil(store.cachedFeed, "Expected to delete expired cache")
    }

    func test_onEnteringBackground_keepsNonExpiredFeedCache() {
        let store = InMemoryFeedStore.withNonExpiredFeedCache

        enterBackground(with: store)

        XCTAssertNotNil(store.cachedFeed, "Expected to keep non-expired cache")
    }
    
    func test_onFeedImageSelection_displaysComments() {
        let comments = showCommentsForFirstImage()
        
        XCTAssertEqual(comments.numberOfRenderedCommentViews(), 1)
        XCTAssertEqual(comments.commentMessage(at: 0), "a message")
    }

    // MARK: - Helpers

    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryFeedStore = .empty
    ) -> ListViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store, scheduler: .immediateOnMainQueue)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()

        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! ListViewController
    }

    private func enterBackground(with store: InMemoryFeedStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store, scheduler: .immediateOnMainQueue)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
    
    private func showCommentsForFirstImage() -> ListViewController {
        let feed = launch(httpClient: .online(response), store: .empty)
        
        feed.simulateTapOnFeedImage(at: 0)
        RunLoop.current.run(until: Date())
        
        let nav = feed.navigationController
        return nav?.topViewController as! ListViewController
    }

    private class HTTPClientStub: HTTPClient {
        private class Task: HTTPClientTask {
            func cancel() {}
        }

        private let stub: (URL) -> HTTPClient.Result

        init(stub: @escaping (URL) -> HTTPClient.Result) {
            self.stub = stub
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            completion(stub(url))
            return Task()
        }

        static var offline: HTTPClientStub {
            HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
        }

        static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
            HTTPClientStub { url in .success(stub(url)) }
        }
    }

    private class InMemoryFeedStore: FeedStore, FeedImageDataStore {
        var cachedFeed: CachedFeed?
        private var feedImageDataCache: [URL: Data] = [:]

        private init(cachedFeed: CachedFeed? = nil) {
            self.cachedFeed = cachedFeed
        }

        func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
            cachedFeed = nil
            completion(.success(()))
        }

        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
            cachedFeed = (feed, timestamp)
            completion(.success(()))
        }

        func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
            completion(.success(cachedFeed))
        }

        func insert(_ data: Data, for url: URL) throws {
            feedImageDataCache[url] = data
        }

        func retrieve(dataForURL url: URL) throws -> Data? {
            feedImageDataCache[url]
        }

        static var empty: InMemoryFeedStore {
            InMemoryFeedStore()
        }

        static var withExpiredFeedCache: InMemoryFeedStore {
            InMemoryFeedStore(cachedFeed: CachedFeed(feed: [], timestamp: Date.distantPast))
        }

        static var withNonExpiredFeedCache: InMemoryFeedStore {
            InMemoryFeedStore(cachedFeed: CachedFeed(feed: [], timestamp: Date()))
        }
    }

    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/image-0": return makeImageData0()
        case "/image-1": return makeImageData1()
        case "/image-2": return makeImageData2()
            
        case "/essential-feed/v1/feed" where url.query?.contains("after_id") == false:
            return makeFirstFeedPageData()
            
        case "/essential-feed/v1/feed" where url.query?.contains("after_id=A28F5FE3-27A7-44E9-8DF5-53742D0E4A5A") == true:
            return makeSecondFeedPageData()
            
        case "/essential-feed/v1/feed" where url.query?.contains("after_id=3403DF68-9BF3-4366-A71C-D83E3C699ECF") == true:
            return makeLastFeedPageData()
            
        case "/essential-feed/v1/image/2AB2AE66-A4B7-4A16-B374-51BBAC8DB086/comments":
            return makeCommentsData()
            
        default:
            return Data()
        }
    }

    private func makeImageData0() -> Data { UIImage.make(withColor: .red).pngData()! }
    private func makeImageData1() -> Data { UIImage.make(withColor: .green).pngData()! }
    private func makeImageData2() -> Data { UIImage.make(withColor: .blue).pngData()! }

    private func makeFirstFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "2AB2AE66-A4B7-4A16-B374-51BBAC8DB086", "image": "http://image.com/image-0"],
            ["id": "A28F5FE3-27A7-44E9-8DF5-53742D0E4A5A", "image": "http://image.com/image-1"],
        ]])
    }
    
    private func makeSecondFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "3403DF68-9BF3-4366-A71C-D83E3C699ECF", "image": "http://image.com/image-2"]
        ]])
    }

    private func makeLastFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": []])
    }

    private func makeCommentsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            [
                "id": UUID().uuidString,
                "message": makeCommentMessage(),
                "created_at": "2020-05-20T11:24:59+0000",
                "author": [
                    "username": "a username"
                ]
            ],
        ]])
    }

    private func makeCommentMessage() -> String {
        "a message"
    }
}
