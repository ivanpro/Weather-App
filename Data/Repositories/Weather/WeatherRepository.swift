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
    func fetchWeatherForLocationSuccess()
    func fetchWeatherForLocationError()
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
        self.client.fetchWatherForLocation("Sydney", onSuccess: { json in
            let weather = Weather(with: json)
            print(weather?.detail?.description)
            print(weather?.detail?.icon)
            print(weather?.location?.city)
            print(weather?.location?.country)
            self.fetchDelegate?.fetchWeatherForLocationSuccess()
        }) { (errorCode, json, error) in
            self.fetchDelegate?.fetchWeatherForLocationError()
        }
    }
}
