//
//  PersistenceTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class PersistenceTests: XCTestCase {
    func testAllItemsReturnsArrayInReverseOrder() {
        let defaults = UserDefaultsMock()
        defaults.arrayForKeyReturnValue = ["New York", "Sydney", "London"]
        let persistence = Persistence(defaults: defaults)

        let result = persistence.allItems()
        XCTAssertEqual(result, ["London", "Sydney", "New York"])
    }

    func testAddItemSucceeds() {
        let defaults = UserDefaultsMock()
        defaults.arrayForKeyReturnValue = []
        let persistence = Persistence(defaults: defaults)

        persistence.addItem("Sydney")
        XCTAssertEqual(defaults.setForKeyReceivedArguments?.value as? [String], ["Sydney"])
    }

    func testRemoveItemSucceeds() {
        let defaults = UserDefaultsMock()
        defaults.arrayForKeyReturnValue = ["London"]
        let persistence = Persistence(defaults: defaults)

        persistence.removeItem("London")
        XCTAssertEqual(defaults.setForKeyReceivedArguments?.value as? [String], [])
    }

    func testLastStoredItem() {
        let defaults = UserDefaultsMock()
        defaults.arrayForKeyReturnValue = ["London", "Brasilia"]
        let persistence = Persistence(defaults: defaults)

        XCTAssertEqual(persistence.lastStoredItem(), "Brasilia")
    }
}
