//
//  FeedViewController+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Cronay on 23.10.20.
//  Copyright © 2020 Yannic Borgfeld. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeediOS

extension FeedViewControllerTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
