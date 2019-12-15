//
//  FetchLastLocationWeatherUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol FetchLastLocationWeatherUseCaseInterface: AutoMockable {
    func execute() -> Bool

    var delegate: FetchLastLocationWeatherUseCaseDelegate? { get set }
}

protocol FetchLastLocationWeatherUseCaseDelegate: AnyObject {
    func successWeatherResponseForLocation(weather: Weather)
    func failedWeatherResponseForLocation(errorMessage: String)
}

final class FetchLastLocationWeatherUseCase: VoidUseCase<Bool>, FetchLastLocationWeatherUseCaseInterface {
    var fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface
    var retrieveLastSearchedLocation: RetrieveLastSearchedLocationUseCaseInterface
    weak var delegate: FetchLastLocationWeatherUseCaseDelegate?

    init(fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface = FetchWeatherForLocationUseCase(),
         retrieveLastSearchedLocation: RetrieveLastSearchedLocationUseCaseInterface = RetrieveLastSearchedLocationUseCase()) {
        self.fetchWeatherForLocationUseCase = fetchWeatherForLocationUseCase
        self.retrieveLastSearchedLocation = retrieveLastSearchedLocation
    }

    override func execute() -> Bool {
        guard let lastSearchedLocation = retrieveLastSearchedLocation.execute() else { return false }
        fetchWeatherForLocationUseCase.delegate = self
        fetchWeatherForLocationUseCase.execute(lastSearchedLocation)
        return true
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
