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

    var fetchDelegate: FetchWeatherRepositoryDelegate? { get set }
    var iconDelegate: WeatherIconRepositoryDelegate? { get set }
}

protocol FetchWeatherRepositoryDelegate: class {
    func fetchWeatherForLocationSuccess(weather: Weather)
    func fetchWeatherForLocationError(errorMessage: String)
}

protocol WeatherIconRepositoryDelegate: class {
    func fetchWeatherIconSuccess()
    func fetchWeatherIconError()
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
        client.fetchWatherForLocation(location, onSuccess: { json in
            guard let weather = Weather(with: json) else {
                self.fetchDelegate?.fetchWeatherForLocationError(errorMessage: "Failed to parse Weather entity")
                return
            }

            self.fetchDelegate?.fetchWeatherForLocationSuccess(weather: weather)
        }) { (errorCode, json, error) in
            var errorMessage = "Unknown error"
            if let message = error?.localizedDescription {
                errorMessage = "Request Failed: \(message))"
            }

            self.fetchDelegate?.fetchWeatherForLocationError(errorMessage: errorMessage)
        }
    }
}
