//
//  XCTTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Cronay on 14.08.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
