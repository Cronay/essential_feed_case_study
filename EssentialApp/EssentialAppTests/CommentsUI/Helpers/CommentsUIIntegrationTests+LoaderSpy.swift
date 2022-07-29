//
//  CommentsUIIntegrationTests+LoaderSpy.swift
//  EssentialAppTests
//
//  Created by Yannic Borgfeld on 06.02.22.
//

import XCTest
import Combine
import EssentialFeed
import EssentialFeediOS

extension CommentsUIIntegrationTests {
    class LoaderSpy {
        private var commentsRequests = [PassthroughSubject<[ImageComment], Error>]()

        var loadCommentsCallCount: Int {
            return commentsRequests.count
        }
        
        func loadPublisher() -> AnyPublisher<[ImageComment], Error> {
            let publisher = PassthroughSubject<[ImageComment], Error>()
            commentsRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }

        func completeCommentsLoading(with comments: [ImageComment] = [], at index: Int = 0) {
            commentsRequests[index].send(comments)
            commentsRequests[index].send(completion: .finished)
        }

        func completeCommentsLoadingWithError(at index: Int) {
            let error = NSError(domain: "an error", code: 0)
            commentsRequests[index].send(completion: .failure(error))
        }
    }
}
