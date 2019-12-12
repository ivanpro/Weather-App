//
//  FetchLastLocationWeatherUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol FetchLastLocationWeatherUseCaseInterface {}

final class FetchLastLocationWeatherUseCase: UseCase<String, String>, FetchLastLocationWeatherUseCaseInterface {
    let weatherRepository: WeatherRepositoryInterface

    init(weatherRepository: WeatherRepositoryInterface = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    override func execute(_ input: String) -> String {
        // Ask client to fetch result
        return ""
    }
}
