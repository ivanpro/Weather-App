//
//  TemperatureTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class TemperatureTests: XCTestCase {
    func testParsesJson() {
        let json = Fixture.toDictionary("sample_successful_request")
        let temperature = Temperature(with: json)

        XCTAssertEqual(temperature?.humidity, 96)
        XCTAssertEqual(temperature?.pressure, 1017)
        XCTAssertEqual(temperature?.temp, 286.164)
        XCTAssertEqual(temperature?.tempMax, 286.164)
        XCTAssertEqual(temperature?.tempMin, 286.164)
    }

    func testParsesJsonFailsIfKeyIsMissing() {
        var json = Fixture.toDictionary("sample_successful_request")
        var main = json.dictionary(forKey: "main")
        main?.removeValue(forKey: "temp")
        json["main"] = main

        let temperature = Temperature(with: json)

        XCTAssertNil(temperature)
    }
}
