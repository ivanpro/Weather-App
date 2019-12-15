//
//  RetrieveLastSearchedLocationUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class RetrieveLastSearchedLocationUseCaseTests: XCTestCase {
    func testExecuteRetrievesLastItem() {
        let persistence = PersistenceMock()
        persistence.lastStoredItemReturnValue = "TestValue"
        let useCase = RetrieveLastSearchedLocationUseCase(persistence: persistence)

        XCTAssertEqual(useCase.execute(), "TestValue")
    }
}
