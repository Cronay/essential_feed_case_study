//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Cronay on 22.11.20.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {

    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window

        sut.configureWindow()

        XCTAssertEqual(window.makeKeyCallCount, 1, "Expected window to be key window")
        XCTAssertFalse(window.isHidden, "Expected window to be visible")
    }

    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()

        sut.configureWindow()

        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController

        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is ListViewController)
    }

    // MARK: - Helpers
    
    private class UIWindowSpy: UIWindow {
        var makeKeyCallCount = 0
        
        override func makeKey() {
            makeKeyCallCount += 1
        }
    }
}
