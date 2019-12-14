//
//  FetchWeatherForLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol FetchWeatherForLocationUseCaseInterface {
    func execute(_ input: String)

    var delegate: FetchWeatherForLocationUseCaseDelegate? { get set }
}

protocol FetchWeatherForLocationUseCaseDelegate: AnyObject {
    func successWeatherResponseForLocation(_ weather: Weather)
    func failedWeatherResponseForLocation(_ errorMessage: String)
}

final class FetchWeatherForLocationUseCase: UseCase<String>, FetchWeatherForLocationUseCaseInterface {
    var weatherRepository: WeatherRepositoryInterface
    weak var delegate: FetchWeatherForLocationUseCaseDelegate?

    init(weatherRepository: WeatherRepositoryInterface = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    override func execute(_ input: String) {
        self.weatherRepository.fetchDelegate = self
        weatherRepository.fetchWeatherForLocation(input)
    }
}

extension FetchWeatherForLocationUseCase: FetchWeatherRepositoryDelegate {
    func fetchWeatherForLocationSuccess(weather: Weather) {
        UserDefaults.standard.setValue(weather.location?.city, forKey: "lastSearch")
        delegate?.successWeatherResponseForLocation(weather)
    }

    func fetchWeatherForLocationError(errorMessage: String) {
        delegate?.failedWeatherResponseForLocation(errorMessage)
    }
}
