//
//  CurrentUserLocationUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class CurrentUserLocationUseCaseTests: XCTestCase {

    func testExecuteRunsSuccessfully() {
        let location = LocationMock()
        location.getUserLocationOnCompletionReturnValue = .some(nil)
        location.getUserLocationOnCompletionClosure = { _ in
            location.getUserLocationOnCompletionReceivedOnCompletion?(.userLocation(longitude: 12.34, latitude: 43.21))
            return nil
        }

        let fetchWeatherForCoordinateUseCase = FetchWeatherForCoordinateUseCaseMock()
        let useCase = CurrentUserLocationUseCase(locationWrapper: location,
                                                 fetchWeatherForCoordinateUseCase: fetchWeatherForCoordinateUseCase)

        _ = useCase.execute()

        XCTAssertEqual(fetchWeatherForCoordinateUseCase.executeCallsCount, 1)
        XCTAssertEqual(fetchWeatherForCoordinateUseCase.executeReceivedInput?.longitude, 12.34)
        XCTAssertEqual(fetchWeatherForCoordinateUseCase.executeReceivedInput?.latitude, 43.21)
    }

    func testExecuteFailsAppNoAuthorized() {
        let location = LocationMock()
        location.getUserLocationOnCompletionClosure = { _ in
            location.getUserLocationOnCompletionReceivedOnCompletion?(.appNotAuthorized)
            return nil
        }

        let fetchWeatherForCoordinateUseCase = FetchWeatherForCoordinateUseCaseMock()
        let delegate = CurrentUserLocationUseCaseDelegateMock()
        let useCase = CurrentUserLocationUseCase(locationWrapper: location,
                                                 fetchWeatherForCoordinateUseCase: fetchWeatherForCoordinateUseCase)
        useCase.delegate = delegate
        _ = useCase.execute()

        XCTAssertEqual(fetchWeatherForCoordinateUseCase.executeCallsCount, 0)
        XCTAssertEqual(delegate.failedToAcquireUserLocationErrorMessageCallsCount, 1)
        XCTAssertEqual(delegate.failedToAcquireUserLocationErrorMessageReceivedErrorMessage, "Let us know your location so we can show you pick-up locations nearby.")
    }

    func testExecuteFailsDeviceLocationDisabled() {
        let location = LocationMock()
        location.getUserLocationOnCompletionClosure = { _ in
            location.getUserLocationOnCompletionReceivedOnCompletion?(.deviceLocationServicesDisabled)
            return nil
        }

        let fetchWeatherForCoordinateUseCase = FetchWeatherForCoordinateUseCaseMock()
        let delegate = CurrentUserLocationUseCaseDelegateMock()
        let useCase = CurrentUserLocationUseCase(locationWrapper: location,
                                                 fetchWeatherForCoordinateUseCase: fetchWeatherForCoordinateUseCase)
        useCase.delegate = delegate
        _ = useCase.execute()

        XCTAssertEqual(fetchWeatherForCoordinateUseCase.executeCallsCount, 0)
        XCTAssertEqual(delegate.failedToAcquireUserLocationErrorMessageCallsCount, 1)
        XCTAssertEqual(delegate.failedToAcquireUserLocationErrorMessageReceivedErrorMessage, "Please turn on your location services via settings so we can show you pick-up locations nearby.")
    }

    func testExecuteFailsUnkownError() {
        let location = LocationMock()
        location.getUserLocationOnCompletionClosure = { _ in
            location.getUserLocationOnCompletionReceivedOnCompletion?(.error)
            return nil
        }

        let fetchWeatherForCoordinateUseCase = FetchWeatherForCoordinateUseCaseMock()
        let delegate = CurrentUserLocationUseCaseDelegateMock()
        let useCase = CurrentUserLocationUseCase(locationWrapper: location,
                                                 fetchWeatherForCoordinateUseCase: fetchWeatherForCoordinateUseCase)
        useCase.delegate = delegate
        _ = useCase.execute()

        XCTAssertEqual(fetchWeatherForCoordinateUseCase.executeCallsCount, 0)
        XCTAssertEqual(delegate.failedToAcquireUserLocationErrorMessageCallsCount, 1)
        XCTAssertEqual(delegate.failedToAcquireUserLocationErrorMessageReceivedErrorMessage, "Could not retrieve your location right now. Please try again later.")
    }

    func testFetchWeatherForCoordinateDelegateSuccess() throws {
        let delegate = CurrentUserLocationUseCaseDelegateMock()
        let useCase = CurrentUserLocationUseCase.mock()
        useCase.delegate = delegate

        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))
        useCase.successWeatherResponseForLocation(weather)

        XCTAssertEqual(delegate.weatherForUserLocationCallsCount, 1)
        XCTAssertEqual(delegate.weatherForUserLocationReceivedWeather?.location?.city, "London")
     }

    func testFetchWeatherForCoordinateDelegateFails() throws {
        let delegate = CurrentUserLocationUseCaseDelegateMock()
        let useCase = CurrentUserLocationUseCase.mock()
        useCase.delegate = delegate

        useCase.failedWeatherResponseForLocation("Server error")

        XCTAssertEqual(delegate.weatherForUserLocationCallsCount, 0)
        XCTAssertEqual(delegate.failedToAcquireUserLocationErrorMessageCallsCount, 1)
        XCTAssertEqual(delegate.failedToAcquireUserLocationErrorMessageReceivedErrorMessage, "Server error")
     }
}

extension CurrentUserLocationUseCase {
    static func mock(locationWrapper: LocationInterface = LocationMock(),
                     fetchWeatherForCoordinateUseCase: FetchWeatherForCoordinateUseCaseInterface = FetchWeatherForCoordinateUseCaseMock()) -> CurrentUserLocationUseCase {
        return CurrentUserLocationUseCase(locationWrapper: locationWrapper,
                                          fetchWeatherForCoordinateUseCase: fetchWeatherForCoordinateUseCase)
    }
}
