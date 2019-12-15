//
//  FetchWeatherForLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol FetchWeatherForLocationUseCaseInterface: AutoMockable {
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
        guard let encoded = input.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            delegate?.failedWeatherResponseForLocation("Failed to parse city name or zip code")
            return
        }

        weatherRepository.fetchDelegate = self
        weatherRepository.fetchWeatherForLocation(encoded)
    }
}

extension FetchWeatherForLocationUseCase: FetchWeatherRepositoryDelegate {
    func fetchWeatherForLocationSuccess(weather: Weather) {
        delegate?.successWeatherResponseForLocation(weather)
    }

    func fetchWeatherForLocationError(errorMessage: String) {
        delegate?.failedWeatherResponseForLocation(errorMessage)
    }
}
