//
//  AppCoordinatorTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class AppCoordinatorTests: XCTestCase {
    func testStartPushesController() {
        let window = UIWindow()
        let coordinator = AppCoordinator(window: window)

        coordinator.start()

        XCTAssertEqual(coordinator.children.count, 1)
        XCTAssertNotNil(coordinator.children[.map] as? WeatherCoordinator)
    }
}
