//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol WeatherRepositoryInterface {
    func fetchWeatherForLocation(_ location: String)
    func fetchIconForWeather(_ iconName: String)

    var fetchDelegate: FetchWeatherRepositoryDelegate? { get set }
    var iconDelegate: WeatherIconRepositoryDelegate? { get set }
}

protocol FetchWeatherRepositoryDelegate: AnyObject {
    func fetchWeatherForLocationSuccess(weather: Weather)
    func fetchWeatherForLocationError(errorMessage: String)
}

protocol WeatherIconRepositoryDelegate: AnyObject {
    func fetchWeatherForLocationSuccess(_ image: Data)
    func fetchWeatherIconError(_ errorMessage: String)
}

final class WeatherRepository: WeatherRepositoryInterface {
    weak var fetchDelegate: FetchWeatherRepositoryDelegate?
    weak var iconDelegate: WeatherIconRepositoryDelegate?
    var client: WeatherClientInterface

    init(client: WeatherClientInterface = WeatherClient()) {
        self.client = client
    }
}

extension WeatherRepository {
    func fetchWeatherForLocation(_ location: String) {
        client.fetchWatherForLocation(location, onSuccess: { [weak self] json in
            guard let weather = Weather(with: json) else {
                self?.fetchDelegate?.fetchWeatherForLocationError(errorMessage: "Failed to parse Weather entity")
                return
            }

            self?.fetchDelegate?.fetchWeatherForLocationSuccess(weather: weather)
        }) { [weak self] errorMessage in
            self?.fetchDelegate?.fetchWeatherForLocationError(errorMessage: errorMessage)
        }
    }

    func fetchIconForWeather(_ iconName: String) {
        client.fetchIconForWeather(iconName, onSuccess: { [weak self] image in
            self?.iconDelegate?.fetchWeatherForLocationSuccess(image)
        }) { [weak self] errorMessage in
            self?.iconDelegate?.fetchWeatherIconError(errorMessage)
        }
    }
}
