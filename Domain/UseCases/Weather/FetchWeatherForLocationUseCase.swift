//
//  FetchWeatherForLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol FetchWeatherForLocationUseCaseInterface {}

final class FetchWeatherForLocationUseCase: UseCase<String>, FetchWeatherForLocationUseCaseInterface {
    var weatherRepository: WeatherRepositoryInterface

    init(weatherRepository: WeatherRepositoryInterface = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    override func execute(_ input: String) {
        self.weatherRepository.fetchDelegate = self
        weatherRepository.fetchWeatherForLocation(input)
    }
}

extension FetchWeatherForLocationUseCase: FetchWeatherRepositoryDelegate {
    func fetchWeatherForLocationSuccess() {}
    func fetchWeatherForLocationError() {}
}
