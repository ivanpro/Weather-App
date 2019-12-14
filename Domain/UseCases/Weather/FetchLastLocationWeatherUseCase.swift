//
//  FetchLastLocationWeatherUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol FetchLastLocationWeatherUseCaseInterface {
    func execute()

    var delegate: FetchLastLocationWeatherUseCaseDelegate? { get set }
}

protocol FetchLastLocationWeatherUseCaseDelegate: AnyObject {
    func successWeatherResponseForLocation(weather: Weather)
    func failedWeatherResponseForLocation(errorMessage: String)
}

final class FetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface {
    let fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface
    weak var delegate: FetchLastLocationWeatherUseCaseDelegate?

    init(fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface = FetchWeatherForLocationUseCase()) {
        self.fetchWeatherForLocationUseCase = fetchWeatherForLocationUseCase
    }

    func execute() {
        guard let lastSearchedLocation = UserDefaults.standard.string(forKey: "lastSearch") else { return }
        fetchWeatherForLocationUseCase.execute(lastSearchedLocation)
    }
}

extension FetchLastLocationWeatherUseCase: FetchWeatherForLocationUseCaseDelegate {
    func successWeatherResponseForLocation(_ weather: Weather) {
        delegate?.successWeatherResponseForLocation(weather: weather)
    }

    func failedWeatherResponseForLocation(_ errorMessage: String) {
        delegate?.failedWeatherResponseForLocation(errorMessage: errorMessage)
    }
}
