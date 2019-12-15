//
//  RetrieveSearchedLocationsUseCaseTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class RetrieveSearchedLocationsUseCaseTests: XCTestCase {
    func testExecuteRetrievesAllItem() {
        let persistence = PersistenceMock()
        persistence.allItemsReturnValue = ["Sydney", "New York", "London"]
        let useCase = RetrieveSearchedLocationsUseCase(persistence: persistence)

        XCTAssertEqual(useCase.execute(), ["Sydney", "New York", "London"])
    }
}
