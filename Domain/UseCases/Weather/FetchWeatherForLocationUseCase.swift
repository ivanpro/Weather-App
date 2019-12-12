//
//  FetchWeatherForLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol FetchWeatherForLocationUseCaseInterface {}

final class FetchWeatherForLocationUseCase: UseCase<String, String>, FetchWeatherForLocationUseCaseInterface {
    let weatherRepository: WeatherRepositoryInterface

    init(weatherRepository: WeatherRepositoryInterface = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    override func execute(_ input: String) -> String {
        // Ask client to fetch result
        return ""
    }
}
