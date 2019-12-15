//
//  DetailTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class DetailTests: XCTestCase {
    func testParsesJson() {
        let json = Fixture.toDictionary("sample_successful_request")
        let detail = Detail(with: json)

        XCTAssertEqual(detail?.icon, "10n")
        XCTAssertEqual(detail?.description, "light rain")
        XCTAssertEqual(detail?.main, "Rain")
    }

    func testParsesJsonFailsIfKeyIsMissing() {
        var json = Fixture.toDictionary("sample_successful_request")
        var main = json.dictionary(forKey: "weather")
        main?.removeValue(forKey: "icon")
        json["weather"] = main

        let detail = Detail(with: json)

        XCTAssertNil(detail)
    }
}
