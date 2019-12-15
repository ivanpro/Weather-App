//
//  RemoveStoredLocationUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class RemoveStoredLocationUseCaseTests: XCTestCase {
    func testExecuteRemovesItem() {
        let persistence = PersistenceMock()
        let useCase = RemoveStoredLocationUseCase(persistence: persistence)

        useCase.execute("SomeKey")

        XCTAssertEqual(persistence.removeItemCallsCount, 1)
        XCTAssertEqual(persistence.removeItemReceivedValue, "SomeKey")
    }
}
