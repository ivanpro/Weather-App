//
//  SearchViewModelTests.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 16/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import XCTest
@testable import WeatherApp

class SearchViewModelTests: XCTestCase {
    func testViewDidLoadTriggersDatasourceDelegate() throws {
        let delegate = SearchViewModelDataSourceDelegateMock()
        let retrieveUseCase = RetrieveSearchedLocationsUseCaseMock()
        retrieveUseCase.executeReturnValue = ["Sydney", "Melbourne"]
        let viewModel = SearchViewModel.mock(retrieveSearchedLocationsUseCase: retrieveUseCase)
        viewModel.dataSourceDelegate = delegate

        viewModel.viewDidLoad()

        XCTAssertEqual(delegate.reloadTableWithRecentLocationsCallsCount, 1)
        XCTAssertEqual(delegate.reloadTableWithRecentLocationsReceivedLocations, ["Sydney", "Melbourne"])
    }

    func testTextFieldDidEndEditing() throws {
        let fetchWeatherUseCase = FetchWeatherForLocationUseCaseMock()
        let viewModel = SearchViewModel.mock(fetchWeatherForLocationUseCase: fetchWeatherUseCase)

        viewModel.textFieldDidEndEditing("Test String")

        XCTAssertEqual(fetchWeatherUseCase.executeReceivedInput, "Test String")
    }

    func testTextFieldShouldReturn() throws {
        let fetchWeatherUseCase = FetchWeatherForLocationUseCaseMock()
        let viewModel = SearchViewModel.mock(fetchWeatherForLocationUseCase: fetchWeatherUseCase)

        XCTAssertTrue(viewModel.textFieldShouldReturn("Test String"))
        XCTAssertEqual(fetchWeatherUseCase.executeReceivedInput, "Test String")
    }

    func testFetchWeatherDelegateSuccess() throws {
        let delegate = SearchCoordinatorDelegateMock()
        let viewModel = SearchViewModel.mock()
        viewModel.coordinatorDelegate = delegate

        let weather = try XCTUnwrap(Weather(with: Fixture.toDictionary("sample_successful_request")))
        viewModel.successWeatherResponseForLocation(weather)

        XCTAssertEqual(delegate.fetchWeatherForLocationSuccessfulReceivedWeather, weather)
    }

    func testFetchWeatherDelegateFails() throws {
        let delegate = SearchCoordinatorDelegateMock()
        let viewModel = SearchViewModel.mock()
        viewModel.coordinatorDelegate = delegate

        viewModel.failedWeatherResponseForLocation("Error")

        XCTAssertEqual(delegate.fetchWeatherForLocationFailedReceivedErrorMessage, "Error")
    }

    func testSearchViewModelDelegateRemoveLocation() {
        let delegate = SearchViewModelDataSourceDelegateMock()
        let removeUseCase = RemoveStoredLocationUseCaseMock()
        let retrieveUseCase = RetrieveSearchedLocationsUseCaseMock()
        retrieveUseCase.executeReturnValue = []
        let viewModel = SearchViewModel.mock(retrieveSearchedLocationsUseCase: retrieveUseCase, removeStoredLocationUseCase: removeUseCase)
        viewModel.dataSourceDelegate = delegate

        viewModel.didRemoveLocation("Test")

        XCTAssertEqual(removeUseCase.executeReceivedInput, "Test")
        XCTAssertEqual(delegate.reloadTableWithRecentLocationsReceivedLocations, [])
    }

    func testSearchViewModelDelegateSelectLocation() {
        let fetchWeatherUseCase = FetchWeatherForLocationUseCaseMock()
        let viewModel = SearchViewModel.mock(fetchWeatherForLocationUseCase: fetchWeatherUseCase)

        viewModel.didSelectLocation("Test")

        XCTAssertEqual(fetchWeatherUseCase.executeReceivedInput, "Test")
    }
}

extension SearchViewModel {
    static func mock(fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface = FetchWeatherForLocationUseCaseMock(),
    retrieveSearchedLocationsUseCase: RetrieveSearchedLocationsUseCaseInterface = RetrieveSearchedLocationsUseCaseMock(),
    removeStoredLocationUseCase: RemoveStoredLocationUseCaseInterface = RemoveStoredLocationUseCaseMock()) -> SearchViewModel {
        return SearchViewModel(fetchWeatherForLocationUseCase: fetchWeatherForLocationUseCase,
                               retrieveSearchedLocationsUseCase: retrieveSearchedLocationsUseCase,
                               removeStoredLocationUseCase: removeStoredLocationUseCase)
    }
}
