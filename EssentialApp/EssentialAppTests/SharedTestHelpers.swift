//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Cronay on 13.11.20.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}
