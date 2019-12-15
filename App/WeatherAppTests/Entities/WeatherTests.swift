//
//  WeatherTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherTests: XCTestCase {
    func testParsesJson() {
        let json = Fixture.toDictionary("sample_successful_request")
        let weather = Weather(with: json)

        XCTAssertEqual(weather?.detail?.icon, "10n")
        XCTAssertEqual(weather?.location?.city, "London")
        XCTAssertEqual(weather?.temperature?.temp, 286.164)
        XCTAssertEqual(weather?.wind?.speed, 3.61)
    }
}
