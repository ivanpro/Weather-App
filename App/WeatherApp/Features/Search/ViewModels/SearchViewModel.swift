//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 14/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol SearchViewModelDataSourceDelegate: AnyObject {
    func reloadTableWithRecentLocations(_ locations: [String])
}

protocol SearchViewModelDataSourceInterface: AutoMockable {
    func didSelectLocation(_ location: String)
    func didRemoveLocation(_ location: String)
}

protocol SearchViewModelInterface: SearchViewModelDataSourceInterface {
    func viewDidLoad()
    func textFieldShouldReturn(_ text: String?) -> Bool

    var coordinatorDelegate: SearchCoordinatorDelegate? { get set }
    var dataSourceDelegate: SearchViewModelDataSourceDelegate? { get set }
}

protocol SearchCoordinatorDelegate: AnyObject {
    func fetchWeatherForLocationSuccessful(_ weather: Weather)
    func fetchWeatherForLocationFailed(_ errorMessage: String)
}

final class SearchViewModel: SearchViewModelInterface {
    weak var coordinatorDelegate: SearchCoordinatorDelegate?
    weak var dataSourceDelegate: SearchViewModelDataSourceDelegate?

    var fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface
    var retrieveSearchedLocationsUseCase: RetrieveSearchedLocationsUseCaseInterface
    var removeStoredLocationUseCase: RemoveStoredLocationUseCaseInterface

    init(fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface = FetchWeatherForLocationUseCase(),
         retrieveSearchedLocationsUseCase: RetrieveSearchedLocationsUseCaseInterface = RetrieveSearchedLocationsUseCase(),
         removeStoredLocationUseCase: RemoveStoredLocationUseCaseInterface = RemoveStoredLocationUseCase()) {
        self.fetchWeatherForLocationUseCase = fetchWeatherForLocationUseCase
        self.retrieveSearchedLocationsUseCase = retrieveSearchedLocationsUseCase
        self.removeStoredLocationUseCase = removeStoredLocationUseCase
    }

    func viewDidLoad() {
        fetchWeatherForLocationUseCase.delegate = self
        dataSourceDelegate?.reloadTableWithRecentLocations(retrieveSearchedLocationsUseCase.execute())
    }
}

extension SearchViewModel {
    // MARK: - ViewController Actions
    func textFieldDidEndEditing(_ text: String?) {
        guard let text = text else { return }
        fetchWeatherForLocationUseCase.execute(text)
    }

    func textFieldShouldReturn(_ text: String?) -> Bool {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return false }
        fetchWeatherForLocationUseCase.execute(text)
        return true
    }
}

extension SearchViewModel: FetchWeatherForLocationUseCaseDelegate {
    // MARK: - FetchWeatherForLocationUseCaseDelegate
    func successWeatherResponseForLocation(_ weather: Weather) {
        coordinatorDelegate?.fetchWeatherForLocationSuccessful(weather)
    }

    func failedWeatherResponseForLocation(_ errorMessage: String) {
        coordinatorDelegate?.fetchWeatherForLocationFailed(errorMessage)
    }
}

extension SearchViewModel: SearchViewModelDataSourceInterface {
    func didRemoveLocation(_ location: String) {
        removeStoredLocationUseCase.execute(location)
        dataSourceDelegate?.reloadTableWithRecentLocations(retrieveSearchedLocationsUseCase.execute())
    }

    func didSelectLocation(_ location: String) {
        fetchWeatherForLocationUseCase.execute(location)
    }
}
