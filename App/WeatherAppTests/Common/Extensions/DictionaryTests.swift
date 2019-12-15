//
//  DictionaryTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class DictionaryTests: XCTestCase {
    func testDictionaryRetrievesStringValue() {
        let dictionary = ["Test1": "String1", "Test2": "String2"]
        XCTAssertEqual(dictionary.string(forKey: "Test2"), "String2")
    }

    func testDictionaryFailsToRetrieveStringValueWhenNoKeysFound() {
        let dictionary = [String: String]()
        XCTAssertNil(dictionary.string(forKey: "Test2"))
    }

    func testDictionaryFailsToRetrieveStringValueWhenNotString() {
        let dictionary = ["Test1": 22, "Test2": 33]
        XCTAssertNil(dictionary.string(forKey: "Test1"))
    }

    func testDictionaryRetrievesFloatValue() {
        let dictionary = ["Test1": 4.44, "Test2": 22.33]
        XCTAssertEqual(dictionary.float(forKey: "Test2"), 22.33)
    }

    func testDictionaryRetrievesIntValue() {
        let dictionary = ["Test1": 4, "Test2": 2]
        XCTAssertEqual(dictionary.int(forKey: "Test2"), 2)
    }

    func testDictionaryFailsToRetrieveNumberWhenNoKeysFound() {
        let dictionary = [String: String]()
        XCTAssertNil(dictionary.number(forKey: "Test1"))
    }

    func testDictionaryFailsToRetrieveNumberWhenNotNumber() {
        let dictionary = ["Test1": "String1", "Test2": "String2"]
        XCTAssertNil(dictionary.number(forKey: "Test1"))
    }

    func testDictionaryRetrievesDictionaryValue() {
        let dictionary = ["Dict": ["Test1": "String1", "Test2": "String2"]]
        XCTAssertEqual(dictionary.dictionary(forKey: "Dict") as? [String: String], ["Test1": "String1", "Test2": "String2"])
    }

    func testDictionaryFailstToRetrieveDictionaryValueWhenNoKey() {
        let dictionary = [String: [String: String]]()
        XCTAssertNil(dictionary.dictionary(forKey: "Dict"))
    }

    func testDictionaryFailstToRetrieveDictionaryValueNotDictionary() {
        let dictionary = ["Test1": 4, "Test2": 2]
        XCTAssertNil(dictionary.dictionary(forKey: "Test1"))
    }

    func testArrayRetrievesValue() {
        let dictionary = ["Array": ["Test1", "String1", "Test2", "String2"]]
        XCTAssertEqual(dictionary.array(forKey: "Array") as? [String], ["Test1", "String1", "Test2", "String2"])
    }

    func testFailstToRetrieveArrayValueWhenNoKey() {
        let dictionary = [String: [String: String]]()
        XCTAssertNil(dictionary.dictionary(forKey: "Array"))
    }

    func testFailstToRetrieveArrayValueNotArray() {
        let dictionary = ["Array": 2]
        XCTAssertNil(dictionary.dictionary(forKey: "Array"))
    }
}
