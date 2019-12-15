//
//  StoreSearchedLocationUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class StoreSearchedLocationUseCaseTests: XCTestCase {
    func testExecuteAddsItem() {
        let persistence = PersistenceMock()
        let useCase = StoreSearchedLocationUseCase(persistence: persistence)

        useCase.execute("Porto Alegre")

        XCTAssertEqual(persistence.addItemCallsCount, 1)
        XCTAssertEqual(persistence.addItemReceivedValue, "Porto Alegre")
    }
}
