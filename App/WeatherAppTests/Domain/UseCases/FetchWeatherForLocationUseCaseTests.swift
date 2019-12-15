//
//  FetchWeatherForLocationUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class FetchWeatherForLocationUseCaseTests: XCTestCase {
    func testExecuteCallsRepositorySuccessfully() {
        let repository = WeatherRepositoryMock()
        let useCase = FetchWeatherForLocationUseCase(weatherRepository: repository)

        useCase.execute("New York")

        XCTAssertEqual(repository.fetchWeatherForLocationCallsCount, 1)
        XCTAssertEqual(repository.fetchWeatherForLocationReceivedLocation, "New%20York")

        useCase.execute("Sydney")

        XCTAssertEqual(repository.fetchWeatherForLocationCallsCount, 2)
        XCTAssertEqual(repository.fetchWeatherForLocationReceivedLocation, "Sydney")
    }

    func testFetchWeatherDelegateReturnsSuccessfully() throws {
        let delegate = FetchWeatherForLocationUseCaseDelegateMock()
        let useCase = FetchWeatherForLocationUseCase()
        useCase.delegate = delegate

        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))
        useCase.fetchWeatherForLocationSuccess(weather: weather)

        useCase.fetchWeatherForLocationSuccess(weather: weather)
        XCTAssertEqual(delegate.successWeatherResponseForLocationReceivedWeather, weather)
    }

    func testFetchWeatherDelegateReturnsFailed() {
        let delegate = FetchWeatherForLocationUseCaseDelegateMock()
        let useCase = FetchWeatherForLocationUseCase()
        useCase.delegate = delegate

        useCase.fetchWeatherForLocationError(errorMessage: "Unknown error")

        XCTAssertEqual(delegate.failedWeatherResponseForLocationCallsCount, 1)
        XCTAssertEqual(delegate.failedWeatherResponseForLocationReceivedErrorMessage, "Unknown error")
        XCTAssertEqual(delegate.successWeatherResponseForLocationCallsCount, 0)
    }
}
