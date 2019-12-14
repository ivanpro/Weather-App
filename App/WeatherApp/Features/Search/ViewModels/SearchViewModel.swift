//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 14/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol SearchViewModelInterface {
    func viewDidLoad()
    func textFieldShouldReturn(_ text: String?) -> Bool

    var delegate: SearchViewModelDelegate? { get set }
    var coordinatorDelegate: SearchCoordinatorDelegate? { get set }
}

protocol SearchCoordinatorDelegate: AnyObject {
    func fetchWeatherForLocationSuccessful(_ weather: Weather)
    func fetchWeatherForLocationFailed(_ errorMessage: String)
}

protocol SearchViewModelDelegate: AnyObject {}

final class SearchViewModel: SearchViewModelInterface {
    weak var delegate: SearchViewModelDelegate?
    weak var coordinatorDelegate: SearchCoordinatorDelegate?
    var fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface

    init(fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface = FetchWeatherForLocationUseCase()) {
        self.fetchWeatherForLocationUseCase = fetchWeatherForLocationUseCase
    }

    func viewDidLoad() {
        fetchWeatherForLocationUseCase.delegate = self
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
