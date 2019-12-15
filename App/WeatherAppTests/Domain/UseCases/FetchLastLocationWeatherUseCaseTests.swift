//
//  FetchLastLocationWeatherUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class FetchLastLocationWeatherUseCaseTests: XCTestCase {
    func testExecuteSuccessfullyCallsFetchWeather() {
        let retrieveUseCase = RetrieveLastSearchedLocationUseCaseMock()
        retrieveUseCase.executeReturnValue = "New York"
        let fetchUseCase = FetchWeatherForLocationUseCaseMock()
        let useCase = FetchLastLocationWeatherUseCase.mock(fetchWeatherForLocationUseCase: fetchUseCase, retrieveLastSearchedLocation: retrieveUseCase)

        XCTAssertTrue(useCase.execute())
        XCTAssertEqual(retrieveUseCase.executeCallsCount, 1)
        XCTAssertEqual(fetchUseCase.executeCallsCount, 1)
        XCTAssertEqual(fetchUseCase.executeReceivedInput, "New York")
    }

    func testExecuteFailsWhenNoLastLocationFound() {
        let retrieveUseCase = RetrieveLastSearchedLocationUseCaseMock()
        retrieveUseCase.executeClosure = {
            return nil
        }
        let fetchUseCase = FetchWeatherForLocationUseCaseMock()
        let useCase = FetchLastLocationWeatherUseCase.mock(fetchWeatherForLocationUseCase: fetchUseCase, retrieveLastSearchedLocation: retrieveUseCase)

        XCTAssertFalse(useCase.execute())
        XCTAssertEqual(retrieveUseCase.executeCallsCount, 1)
        XCTAssertEqual(fetchUseCase.executeCallsCount, 0)
    }

    func testFetchLastLocationDelegateSuccessfully() throws {
        let delegate = FetchLastLocationWeatherUseCaseDelegateMock()
        let useCase = FetchLastLocationWeatherUseCase.mock()
        useCase.delegate = delegate

        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))
        useCase.successWeatherResponseForLocation(weather)

        XCTAssertEqual(delegate.successWeatherResponseForLocationWeatherCallsCount, 1)
        XCTAssertEqual(delegate.successWeatherResponseForLocationWeatherReceivedWeather, weather)
    }

    func testFetchLastLocationDelegateFails() throws {
        let delegate = FetchLastLocationWeatherUseCaseDelegateMock()
        let useCase = FetchLastLocationWeatherUseCase.mock()
        useCase.delegate = delegate

        useCase.failedWeatherResponseForLocation("Server error")

        XCTAssertEqual(delegate.successWeatherResponseForLocationWeatherCallsCount, 0)
        XCTAssertEqual(delegate.failedWeatherResponseForLocationErrorMessageCallsCount, 1)
        XCTAssertEqual(delegate.failedWeatherResponseForLocationErrorMessageReceivedErrorMessage, "Server error")
    }
}

extension FetchLastLocationWeatherUseCase {
    static func mock(fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface = FetchWeatherForLocationUseCaseMock(),
                     retrieveLastSearchedLocation: RetrieveLastSearchedLocationUseCaseInterface = RetrieveLastSearchedLocationUseCaseMock()) -> FetchLastLocationWeatherUseCase {
        return FetchLastLocationWeatherUseCase(fetchWeatherForLocationUseCase: fetchWeatherForLocationUseCase, retrieveLastSearchedLocation: retrieveLastSearchedLocation)
    }
}
