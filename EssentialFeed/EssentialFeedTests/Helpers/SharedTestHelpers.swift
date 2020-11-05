//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Cronay on 04.09.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}
