//
//  LocationTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class LocationTests: XCTestCase {
    func testParsesJson() {
        let json = Fixture.toDictionary("sample_successful_request")
        let location = Location(with: json)

        XCTAssertEqual(location?.country, "GB")
        XCTAssertEqual(location?.city, "London")
    }

    func testParsesJsonFailsIfKeyIsMissing() {
        var json = Fixture.toDictionary("sample_successful_request")
        json.removeValue(forKey: "name")

        let location = Location(with: json)

        XCTAssertNil(location)
    }
}
