//
//  WeatherCoordinatorTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherCoordinatorTests: XCTestCase {
    func testStartPushesController() throws {
        let navigation = UINavigationController()
        let viewModel = WeatherViewModelMock()
        let coordinator = WeatherCoordinator(navigationController: navigation, viewModel: viewModel)

        coordinator.start()

        XCTAssertEqual(navigation.viewControllers.count, 1)
        let searchVC = try XCTUnwrap(navigation.viewControllers.first)
        XCTAssertNotNil(searchVC as? WeatherViewController)
        XCTAssertEqual(searchVC.title, "Gumtree Weather")
    }

    func testPresentSearchPushesSearchCoordinator() throws {
        let navigation = UINavigationController()
        let viewModel = WeatherViewModelMock()
        let coordinator = WeatherCoordinator(navigationController: navigation, viewModel: viewModel)

        coordinator.presentSearchScreen()
        XCTAssertEqual(coordinator.children.count, 1)
        XCTAssertNotNil(coordinator.children[.search] as? SearchCoordinator)
    }

    func testSearchDelegateSuccess() throws {
        let navigation = UINavigationController()
        let viewModel = WeatherViewModelMock()
        let coordinator = WeatherCoordinator(navigationController: navigation, viewModel: viewModel)

        coordinator.presentSearchScreen()
        XCTAssertEqual(coordinator.children.count, 1)
        XCTAssertNotNil(coordinator.children[.search] as? SearchCoordinator)

        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))
        coordinator.fetchWeatherForLocationSuccessful(weather)

        XCTAssertEqual(coordinator.children.count, 0)
        XCTAssertNil(coordinator.children[.search])
        XCTAssertEqual(viewModel.loadWeatherReceivedWeather, weather)
    }

    func testSearchDelegateFails() throws {
        let navigation = UINavigationController()
        let viewModel = WeatherViewModelMock()
        let coordinator = WeatherCoordinator(navigationController: navigation, viewModel: viewModel)

        coordinator.presentSearchScreen()
        XCTAssertEqual(coordinator.children.count, 1)
        XCTAssertNotNil(coordinator.children[.search] as? SearchCoordinator)

        coordinator.fetchWeatherForLocationFailed("Some error")

        XCTAssertEqual(coordinator.children.count, 0)
        XCTAssertNil(coordinator.children[.search])
        XCTAssertEqual(viewModel.searchFailedReceivedErrorMessage, "Some error")
    }
}
