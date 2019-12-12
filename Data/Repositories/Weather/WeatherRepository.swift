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

    private let fetchQueue: DispatchQueue = DispatchQueue(label: "com.vitorll.weather_repository_fetch_queue", qos: .utility, attributes: .concurrent)
    private let iconQueue: DispatchQueue = DispatchQueue(label: "com.vitorll.weather_repository_icon_queue", qos: .utility, attributes: .concurrent)

    init(client: WeatherClientInterface = WeatherClient()) {
        self.client = client
    }
}

extension WeatherRepository {
    func fetchWeatherForLocation(_ location: String) {
        fetchQueue.async {
            // Call client
            self.client.fetchWatherForLocation(location, onSuccess: { text in
                DispatchQueue.main.async {
                    self.fetchDelegate?.fetchWeatherForLocationSuccess()
                }
            }) { (errorCode, json, error) in
                DispatchQueue.main.async {
                    self.fetchDelegate?.fetchWeatherForLocationError()
                }
            }
        }
    }
}
