//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Yannic Borgfeld on 28.01.22.
//  Copyright © 2022 Yannic Borgfeld. All rights reserved.
//

import XCTest
import EssentialFeed

final class SharedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        assertLocalizedKeysAndValuesExists(in: bundle, table: table)
    }

    // MARK: - Helpers
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
}

