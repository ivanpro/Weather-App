//
//  SearchCoordinatorTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class SearchCoordinatorTests: XCTestCase {
    func testStartPushesController() throws {
        let navigation = UINavigationController()
        let viewModel = SearchViewModelMock()
        let coordinator = SearchCoordinator(navigationController: navigation, viewModel: viewModel)

        coordinator.start()

        XCTAssertEqual(navigation.viewControllers.count, 1)
        let searchVC = try XCTUnwrap(navigation.viewControllers.first)
        XCTAssertNotNil(searchVC as? SearchViewController)
        XCTAssertEqual(searchVC.title, "Search")
    }
}
