//
//  FetchWeatherForCoordinateUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

typealias Coordinate = (latitude: Double, longitude: Double)
protocol FetchWeatherForCoordinateUseCaseInterface {
    func execute(_ input: Coordinate)

    var delegate: FetchWeatherForCoordinateUseCaseDelegate? { get set }
}

protocol FetchWeatherForCoordinateUseCaseDelegate: AnyObject {
    func successWeatherResponseForLocation(_ weather: Weather)
    func failedWeatherResponseForLocation(_ errorMessage: String)
}

final class FetchWeatherForCoordinateUseCase: UseCase<Coordinate>, FetchWeatherForCoordinateUseCaseInterface {
    var weatherRepository: WeatherRepositoryInterface
    weak var delegate: FetchWeatherForCoordinateUseCaseDelegate?

    init(weatherRepository: WeatherRepositoryInterface = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    override func execute(_ input: Coordinate) {
        weatherRepository.fetchDelegate = self
        weatherRepository.fetchWeatherForCoordinate(input)
    }
}

extension FetchWeatherForCoordinateUseCase: FetchWeatherRepositoryDelegate {
    func fetchWeatherForLocationSuccess(weather: Weather) {
        delegate?.successWeatherResponseForLocation(weather)
    }

    func fetchWeatherForLocationError(errorMessage: String) {
        delegate?.failedWeatherResponseForLocation(errorMessage)
    }
}
