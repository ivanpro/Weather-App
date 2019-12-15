//
//  WeatherRepositoryTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherRepositoryTests: XCTestCase {
    let coordinates = (latitude: 12.34, longitude: 43.21)

    func testFetchWeatherForLocationReturnsSuccessfully() {
        let client = WeatherClientMock()
        let repository = WeatherRepository.mock(client: client)

        repository.fetchWeatherForLocation("Sydney")

        XCTAssertTrue(client.fetchWatherForLocationOnSuccessOnErrorCalled)
        XCTAssertEqual(client.fetchWatherForLocationOnSuccessOnErrorCallsCount, 1)
        XCTAssertEqual(client.fetchWatherForLocationOnSuccessOnErrorReceivedArguments?.location, "Sydney")
    }

    func testFetchWeatherForLocationReturnsErrorWhenUnsuccessful() {
        let client = WeatherClientMock()
        let delegate = FetchWeatherRepositoryDelegateMock()
        client.fetchWatherForLocationOnSuccessOnErrorClosure = { _, _, onError in
            onError?("Server error")
        }

        let repository = WeatherRepository.mock(client: client)
        repository.fetchDelegate = delegate

        repository.fetchWeatherForLocation("Sydney")
        XCTAssertEqual(delegate.fetchWeatherForLocationErrorErrorMessageCalled, true)
    }

    func testFetchWeatherForCoordinateReturnsSuccessfully() {
        let client = WeatherClientMock()
        let repository = WeatherRepository.mock(client: client)

        repository.fetchWeatherForCoordinate(coordinates)

        XCTAssertTrue(client.fetchWatherForCoordinatesLongitudeOnSuccessOnErrorCalled)
        XCTAssertEqual(client.fetchWatherForCoordinatesLongitudeOnSuccessOnErrorCallsCount, 1)
        XCTAssertEqual(client.fetchWatherForCoordinatesLongitudeOnSuccessOnErrorReceivedArguments?.latitude, 12.34)
        XCTAssertEqual(client.fetchWatherForCoordinatesLongitudeOnSuccessOnErrorReceivedArguments?.longitude, 43.21)
    }

    func testFetchWeatherForCoordinateReturnsErrorWhenUnsuccessful() {
        let client = WeatherClientMock()
        let delegate = FetchWeatherRepositoryDelegateMock()
        client.fetchWatherForCoordinatesLongitudeOnSuccessOnErrorClosure = { _, _, _, onError in
            onError?("Server error")
        }

        let repository = WeatherRepository.mock(client: client)
        repository.fetchDelegate = delegate

        repository.fetchWeatherForCoordinate(coordinates)
        XCTAssertEqual(delegate.fetchWeatherForLocationErrorErrorMessageCalled, true)
    }

    func testFetchWeatherIconReturnsSuccessfully() {
        let client = WeatherClientMock()
        let repository = WeatherRepository.mock(client: client)

        repository.fetchIconForWeather("11d")

        XCTAssertTrue(client.fetchIconForWeatherOnSuccessOnErrorCalled)
        XCTAssertEqual(client.fetchIconForWeatherOnSuccessOnErrorCallsCount, 1)
        XCTAssertEqual(client.fetchIconForWeatherOnSuccessOnErrorReceivedArguments?.iconId, "11d")
    }

    func testFetchWeatherIconErrorWhenUnsuccessful() {
        let client = WeatherClientMock()
        let delegate = WeatherIconRepositoryDelegateMock()
        client.fetchIconForWeatherOnSuccessOnErrorClosure = { _, _, onError in
            onError?("Server error")
        }

        let repository = WeatherRepository.mock(client: client)
        repository.iconDelegate = delegate

        repository.fetchIconForWeather("11d")
        XCTAssertEqual(delegate.fetchWeatherIconErrorCalled, true)
        XCTAssertEqual(delegate.fetchWeatherIconErrorReceivedErrorMessage, "Server error")
    }

    func testParseSuccessfulRequest() {
        let json = Fixture.toDictionary("sample_successful_request")
        let delegate = FetchWeatherRepositoryDelegateMock()
        let repository = WeatherRepository.mock()

        repository.fetchDelegate = delegate
        repository.parseSuccessfulRequest(json)

        XCTAssertEqual(delegate.fetchWeatherForLocationSuccessWeatherReceivedWeather?.location?.city, "London")
        XCTAssertEqual(delegate.fetchWeatherForLocationSuccessWeatherReceivedWeather?.detail?.icon, "10n")
        XCTAssertEqual(delegate.fetchWeatherForLocationSuccessWeatherReceivedWeather?.temperature?.temp, 286.164)
        XCTAssertEqual(delegate.fetchWeatherForLocationSuccessWeatherReceivedWeather?.wind?.speed, 3.61)
    }

    func testParseSuccessfulRequestFails() {
        let json: JSONDictionary = [String: String]()
        let delegate = FetchWeatherRepositoryDelegateMock()
        let repository = WeatherRepository.mock()

        repository.fetchDelegate = delegate
        repository.parseSuccessfulRequest(json)

        XCTAssertEqual(delegate.fetchWeatherForLocationErrorErrorMessageCalled, true)
        XCTAssertEqual(delegate.fetchWeatherForLocationErrorErrorMessageReceivedErrorMessage, "Failed to parse Weather entity")
    }

    func testParseSuccessfulRequestCallsStoreUseCase() {
        let json = Fixture.toDictionary("sample_successful_request")
        let useCase = StoreSearchedLocationUseCaseMock()
        let repository = WeatherRepository.mock(storeSearchedLocationUseCase: useCase)

        repository.parseSuccessfulRequest(json)

        XCTAssertEqual(useCase.executeCallsCount, 1)
        XCTAssertEqual(useCase.executeReceivedInput, "London")
    }
}

extension WeatherRepository {
    static func mock(client: WeatherClientInterface = WeatherClientMock(),
              storeSearchedLocationUseCase: StoreSearchedLocationUseCaseInterface = StoreSearchedLocationUseCaseMock()) -> WeatherRepository {
            WeatherRepository(client: client, storeSearchedLocationUseCase: storeSearchedLocationUseCase)
    }
}
