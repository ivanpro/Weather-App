//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    func testViewDidLoadSetupUseCase() {
        let fetchLastLocationUseCase = FetchLastLocationWeatherUseCaseMock()
        fetchLastLocationUseCase.executeReturnValue = true

        let viewModel = WeatherViewModel.mock(fetchLastLocationWeatherUseCase: fetchLastLocationUseCase)
        viewModel.viewDidLoad()

        XCTAssertEqual(fetchLastLocationUseCase.executeCallsCount, 1)
    }

    func testViewDidDisappearCancelLocationHandler() {
        var handlerCalled = false

        let locationHandler: (() -> Void)? = {
            handlerCalled = true
        }

        let viewModel = WeatherViewModel.mock()
        viewModel.cancelLocationHandler = locationHandler

        viewModel.viewDidDisappear()

        XCTAssertTrue(handlerCalled)
    }

    func testRequestUseCaseDoNotOpenSearch() {
        let fetchLastLocationUseCase = FetchLastLocationWeatherUseCaseMock()
        let delegate = WeatherCoordinatorDelegateMock()
        fetchLastLocationUseCase.executeReturnValue = false
        let viewModel = WeatherViewModel.mock(fetchLastLocationWeatherUseCase: fetchLastLocationUseCase)
        viewModel.coordinatorDelegate = delegate

        viewModel.requestUseCase()

        XCTAssertEqual(fetchLastLocationUseCase.executeCallsCount, 1)
        XCTAssertFalse(delegate.presentSearchScreenCalled)
    }

    func testRequestUseCaseOpenSearch() {
        let fetchLastLocationUseCase = FetchLastLocationWeatherUseCaseMock()
        let coordinatordelegate = WeatherCoordinatorDelegateMock()
        fetchLastLocationUseCase.executeReturnValue = false
        let viewModel = WeatherViewModel.mock(fetchLastLocationWeatherUseCase: fetchLastLocationUseCase)
        viewModel.coordinatorDelegate = coordinatordelegate

        viewModel.requestUseCase(openSearch: true)

        XCTAssertEqual(fetchLastLocationUseCase.executeCallsCount, 1)
        XCTAssertTrue(coordinatordelegate.presentSearchScreenCalled)
    }

    func testLoadWeatherCallsDelegate() throws {
        let delegate = WeatherViewModelDelegateMock()
        let viewModel = WeatherViewModel.mock()
        viewModel.delegate = delegate

        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))
        viewModel.loadWeather(weather)

        XCTAssertEqual(delegate.stopAnimatingIndicatorCallsCount, 1)
    }

    func testSearchFailedCallsDelegate() throws {
        let delegate = WeatherViewModelDelegateMock()
        let viewModel = WeatherViewModel.mock()
        viewModel.delegate = delegate

        viewModel.searchFailed("Error")

        XCTAssertEqual(delegate.stopAnimatingIndicatorCallsCount, 1)
        XCTAssertEqual(delegate.requestFailedWithReceivedText, "Error")
    }

    func testTryAgainActionOpensSearch() {
        let fetchLastLocationUseCase = FetchLastLocationWeatherUseCaseMock()
        let coordinatordelegate = WeatherCoordinatorDelegateMock()
        fetchLastLocationUseCase.executeReturnValue = false
        let viewModel = WeatherViewModel.mock(fetchLastLocationWeatherUseCase: fetchLastLocationUseCase)
        viewModel.coordinatorDelegate = coordinatordelegate

        viewModel.tryAgainPressed()

        XCTAssertEqual(fetchLastLocationUseCase.executeCallsCount, 1)
        XCTAssertTrue(coordinatordelegate.presentSearchScreenCalled)
    }

    func testSearchPressedCallsDelegate() throws {
        let delegate = WeatherCoordinatorDelegateMock()
        let viewModel = WeatherViewModel.mock()
        viewModel.coordinatorDelegate = delegate

        viewModel.searchPressed()

        XCTAssertEqual(delegate.presentSearchScreenCallsCount, 1)
    }

    func testGpsPressedCallsDelegate() throws {
        let delegate = WeatherViewModelDelegateMock()
        let currentUserLocationUseCase = CurrentUserLocationUseCaseMock()

        let locationHandler: (() -> Void)? = { return }
        currentUserLocationUseCase.executeReturnValue = locationHandler
        let viewModel = WeatherViewModel.mock(currentUserLocationUseCase: currentUserLocationUseCase)
        viewModel.delegate = delegate

        XCTAssertNil(viewModel.cancelLocationHandler)

        viewModel.gpsPressed()

        XCTAssertEqual(delegate.startAnimatingIndicatorCallsCount, 1)
        XCTAssertNotNil(viewModel.cancelLocationHandler)
    }

    func testSuccessWeatherResponse() throws {
        let delegate = WeatherViewModelDelegateMock()
        let getIconUseCase = GetWeatherIconForLocationUseCaseMock()
        let viewModel = WeatherViewModel.mock(getWeatherIconForLocationUseCase: getIconUseCase)
        viewModel.delegate = delegate
        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))

        viewModel.successWeatherResponseForLocation(weather: weather)

        XCTAssertEqual(delegate.stopAnimatingIndicatorCallsCount, 1)
        XCTAssertEqual(delegate.updateLocaleLabelWithReceivedText, "London - GB")
        XCTAssertEqual(delegate.updateTemperatureLabelWithReceivedText, "286.0ºC")
        XCTAssertEqual(getIconUseCase.executeReceivedInput, "10n")
    }

    func testFailedWeatherResponse() {
        let delegate = WeatherViewModelDelegateMock()
        let viewModel = WeatherViewModel.mock()
        viewModel.delegate = delegate

        viewModel.failedWeatherResponseForLocation(errorMessage: "Error message")

        XCTAssertEqual(delegate.requestFailedWithReceivedText, "Error message")
    }

    func testGetWeatherIconSucccess() {
        let delegate = WeatherViewModelDelegateMock()
        let viewModel = WeatherViewModel.mock()
        viewModel.delegate = delegate

        let mockData = Data.init()
        viewModel.successResponseForIcon(mockData)

        XCTAssertEqual(delegate.updateWeatherIconWithReceivedImageData, mockData)
    }

    func testGetWeatherIconFailed() {
        let delegate = WeatherViewModelDelegateMock()
        let viewModel = WeatherViewModel.mock()
        viewModel.delegate = delegate

        viewModel.failedResponseForIcon("Error fetching icon")

        XCTAssertEqual(delegate.requestFailedWithReceivedText, "Error fetching icon")
    }

    func testCurrentLocationDelegateSuccess() throws {
        let delegate = WeatherViewModelDelegateMock()
        let getIconUseCase = GetWeatherIconForLocationUseCaseMock()
        let viewModel = WeatherViewModel.mock(getWeatherIconForLocationUseCase: getIconUseCase)
        viewModel.delegate = delegate
        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))

        viewModel.weatherForUserLocation(weather)

        XCTAssertEqual(delegate.stopAnimatingIndicatorCallsCount, 1)
        XCTAssertEqual(delegate.updateLocaleLabelWithReceivedText, "London - GB")
        XCTAssertEqual(delegate.updateTemperatureLabelWithReceivedText, "286.0ºC")
        XCTAssertEqual(getIconUseCase.executeReceivedInput, "10n")
    }

    func testCurrentLocationDelegateFailed() {
        let delegate = WeatherViewModelDelegateMock()
        let viewModel = WeatherViewModel.mock()
        viewModel.delegate = delegate

        viewModel.failedToAcquireUserLocation(errorMessage: "Location services disabled")

        XCTAssertEqual(delegate.failedToLocateUserReceivedErrorMessage, "Location services disabled")
    }
}

extension WeatherViewModel {
    static func mock(fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface = FetchLastLocationWeatherUseCaseMock(),
                     getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface = GetWeatherIconForLocationUseCaseMock(),
                     currentUserLocationUseCase: CurrentUserLocationUseCaseInterface = CurrentUserLocationUseCaseMock()) -> WeatherViewModel {
        return WeatherViewModel(fetchLastLocationWeatherUseCase: fetchLastLocationWeatherUseCase, getWeatherIconForLocationUseCase: getWeatherIconForLocationUseCase, currentUserLocationUseCase: currentUserLocationUseCase)
    }
}
