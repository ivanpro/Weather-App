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

    var delegate: FetchWeatherForLocationUseDelegate? { get set }
}

protocol FetchWeatherForLocationUseDelegate: class {
    func successWeatherResponseForLocation(weahter: Weather)
    func failedWeatherResponseForLocation(errorMessage: String)
}

final class FetchWeatherForLocationUseCase: UseCase<String>, FetchWeatherForLocationUseCaseInterface {
    var weatherRepository: WeatherRepositoryInterface
    weak var delegate: FetchWeatherForLocationUseDelegate?

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
        delegate?.successWeatherResponseForLocation(weahter: weather)
    }

    func fetchWeatherForLocationError(errorMessage: String) {
        delegate?.failedWeatherResponseForLocation(errorMessage: errorMessage)
    }
}
