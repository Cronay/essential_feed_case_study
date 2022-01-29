//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Yannic Borgfeld on 29.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedKeysAndValuesExists(in: bundle, table: table)
    }
}
