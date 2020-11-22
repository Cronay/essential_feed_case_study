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

    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()

        sut.configureWindow()

        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController

        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedViewController)
    }

}
