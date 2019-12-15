//
//  WindTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WindTests: XCTestCase {
    func testParsesJson() {
        let json = Fixture.toDictionary("sample_successful_request")
        let wind = Wind(with: json)

        XCTAssertEqual(wind?.speed, 3.61)
        XCTAssertEqual(wind?.degree, 165)
    }

    func testParsesJsonFailsIfKeyIsMissing() {
        var json = Fixture.toDictionary("sample_successful_request")
        var main = json.dictionary(forKey: "wind")
        main?.removeValue(forKey: "speed")
        json["wind"] = main

        let wind = Wind(with: json)

        XCTAssertNil(wind)
    }
}
