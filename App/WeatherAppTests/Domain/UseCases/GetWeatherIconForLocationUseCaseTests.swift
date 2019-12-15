//
//  GetWeatherIconForLocationUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class GetWeatherIconForLocationUseCaseTests: XCTestCase {

    func testExecuteCallsRepository() {
        let repository = WeatherRepositoryMock()
        let useCase = GetWeatherIconForLocationUseCase(weatherRepository: repository)

        useCase.execute("11d")

        XCTAssertEqual(repository.fetchIconForWeatherCallsCount, 1)
        XCTAssertEqual(repository.fetchIconForWeatherReceivedIconName, "11d")
    }

    func testWeatherIconcRepositoryDelegateReturnsSuccess() {
        let delegate = GetWeatherIconForLocationUseCaseDelegateMock()
        let useCase = GetWeatherIconForLocationUseCase()
        useCase.delegate = delegate

        let data = Data(capacity: 10)
        useCase.fetchWeatherForLocationSuccess(data)

        XCTAssertEqual(delegate.successResponseForIconCallsCount, 1)
        XCTAssertEqual(delegate.successResponseForIconReceivedImageData, data)
    }

    func testWeatherIconcRepositoryDelegateReturnsFails() {
        let delegate = GetWeatherIconForLocationUseCaseDelegateMock()
        let useCase = GetWeatherIconForLocationUseCase()
        useCase.delegate = delegate

        useCase.fetchWeatherIconError("Image not found")

        XCTAssertEqual(delegate.successResponseForIconCallsCount, 0)
        XCTAssertEqual(delegate.failedResponseForIconCallsCount, 1)
        XCTAssertEqual(delegate.failedResponseForIconReceivedErrorMessage, "Image not found")
    }
}
