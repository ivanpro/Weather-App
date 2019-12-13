//
//  GetWeatherIconForLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol GetWeatherIconForLocationUseCaseInterface {
    func execute(_ input: String)

    var delegate: GetWeatherIconForLocationUseCaseDelegate? { get set }
}

protocol GetWeatherIconForLocationUseCaseDelegate: class {
    func successResponseForIcon(_ imageData: Data)
    func failedResponseForIcon(_ errorMessage: String)
}

final class GetWeatherIconForLocationUseCase: UseCase<String>, GetWeatherIconForLocationUseCaseInterface {
    weak var delegate: GetWeatherIconForLocationUseCaseDelegate?
    var weatherRepository: WeatherRepositoryInterface

    init(weatherRepository: WeatherRepositoryInterface = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    override func execute(_ input: String) {
        weatherRepository.iconDelegate = self
        weatherRepository.fetchIconForWeather(input)
    }
}

extension GetWeatherIconForLocationUseCase: WeatherIconRepositoryDelegate {
    // MARK: - WeatherIconRepositoryDelegate

    func fetchWeatherForLocationSuccess(_ image: Data) {
        delegate?.successResponseForIcon(image)
    }

    func fetchWeatherIconError(_ errorMessage: String) {
        delegate?.failedResponseForIcon(errorMessage)
    }
}
