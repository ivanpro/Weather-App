//
//  FetchWeatherForCoordinateUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class FetchWeatherForCoordinateUseCaseTests: XCTestCase {

    func testExecuteCallsRepository() {
        let repository = WeatherRepositoryMock()
        let useCase = FetchWeatherForCoordinateUseCase(weatherRepository: repository)

        let coordinate = (longitude: 12.34, latitude: 43.21)
        useCase.execute(coordinate)

        XCTAssertEqual(repository.fetchWeatherForCoordinateReceivedCoordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(repository.fetchWeatherForCoordinateReceivedCoordinate?.longitude, coordinate.longitude)
    }

    func testFetchWeatherRespositoryDelegateSuccess() throws {
        let delegate = FetchWeatherForCoordinateUseCaseDelegateMock()
        let useCase = FetchWeatherForCoordinateUseCase()
        useCase.delegate = delegate
        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))

        useCase.fetchWeatherForLocationSuccess(weather: weather)

        XCTAssertEqual(delegate.successWeatherResponseForLocationCallsCount, 1)
        XCTAssertEqual(delegate.successWeatherResponseForLocationReceivedWeather, weather)
    }

    func testFetchWeatherRespositoryDelegateFailed() throws {
        let delegate = FetchWeatherForCoordinateUseCaseDelegateMock()
        let useCase = FetchWeatherForCoordinateUseCase()
        useCase.delegate = delegate

        useCase.fetchWeatherForLocationError(errorMessage: "Server error")

        XCTAssertEqual(delegate.successWeatherResponseForLocationCallsCount, 0)
        XCTAssertEqual(delegate.failedWeatherResponseForLocationCallsCount, 1)
        XCTAssertEqual(delegate.failedWeatherResponseForLocationReceivedErrorMessage, "Server error")
    }
}
