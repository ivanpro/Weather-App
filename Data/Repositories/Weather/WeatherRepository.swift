//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol WeatherRepositoryInterface: AutoMockable {
    func fetchWeatherForLocation(_ location: String)
    func fetchWeatherForCoordinate(_ coordinate: Coordinate)
    func fetchIconForWeather(_ iconName: String)

    var fetchDelegate: FetchWeatherRepositoryDelegate? { get set }
    var iconDelegate: WeatherIconRepositoryDelegate? { get set }
}

protocol FetchWeatherRepositoryDelegate: AnyObject, AutoMockable {
    func fetchWeatherForLocationSuccess(weather: Weather)
    func fetchWeatherForLocationError(errorMessage: String)
}

protocol WeatherIconRepositoryDelegate: AnyObject, AutoMockable {
    func fetchWeatherForLocationSuccess(_ image: Data)
    func fetchWeatherIconError(_ errorMessage: String)
}

final class WeatherRepository: WeatherRepositoryInterface {
    weak var fetchDelegate: FetchWeatherRepositoryDelegate?
    weak var iconDelegate: WeatherIconRepositoryDelegate?
    var storeSearchedLocationUseCase: StoreSearchedLocationUseCaseInterface
    var client: WeatherClientInterface

    init(client: WeatherClientInterface = WeatherClient(),
         storeSearchedLocationUseCase: StoreSearchedLocationUseCaseInterface = StoreSearchedLocationUseCase()) {
        self.client = client
        self.storeSearchedLocationUseCase = storeSearchedLocationUseCase
    }
}

extension WeatherRepository {
    func fetchWeatherForLocation(_ location: String) {
        client.fetchWatherForLocation(location, onSuccess: { [weak self] json in
            self?.parseSuccessfulRequest(json)
        }, onError: { [weak self] errorMessage in
            self?.fetchDelegate?.fetchWeatherForLocationError(errorMessage: errorMessage)
        })
    }

    func fetchWeatherForCoordinate(_ coordinate: Coordinate) {
        client.fetchWatherForCoordinates(coordinate.latitude, longitude: coordinate.longitude, onSuccess: { [weak self] json in
            self?.parseSuccessfulRequest(json)
        }, onError: { [weak self] errorMessage in
            self?.fetchDelegate?.fetchWeatherForLocationError(errorMessage: errorMessage)
        })
    }

    func fetchIconForWeather(_ iconName: String) {
        client.fetchIconForWeather(iconName, onSuccess: { [weak self] image in
            self?.iconDelegate?.fetchWeatherForLocationSuccess(image)
        }, onError: { [weak self] errorMessage in
            self?.iconDelegate?.fetchWeatherIconError(errorMessage)
        })
    }
}

extension WeatherRepository {
    // MARK: - Helper
    func parseSuccessfulRequest(_ json: JSONDictionary) {
        guard let weather = Weather(with: json), weather.location?.city != nil else {
            fetchDelegate?.fetchWeatherForLocationError(errorMessage: "Failed to parse Weather entity")
            return
        }

        fetchDelegate?.fetchWeatherForLocationSuccess(weather: weather)
        guard let searchLocation = weather.location?.city else { return }
        storeSearchedLocationUseCase.execute(searchLocation)
    }
}
