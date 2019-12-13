//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol WeatherViewModelInterface {
    func viewDidLoad()

    var delegate: WeatherViewModelDelegate? { get set }
}

protocol WeatherViewModelDelegate: class {
    func updateTemperatureLabel(with text: String)
    func updateLocaleLabel(with text: String)
}

final class WeatherViewModel: WeatherViewModelInterface {
    weak var delegate: WeatherViewModelDelegate?

    var fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface
    var fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface
    var getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface

    convenience init() {
        self.init(fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCase(),
                  fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCase(),
                  getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCase())
    }

    init(fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface,
         fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface,
         getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface) {
        self.fetchWeatherForLocationUseCase = fetchWeatherForLocationUseCase
        self.fetchLastLocationWeatherUseCase = fetchLastLocationWeatherUseCase
        self.getWeatherIconForLocationUseCase = getWeatherIconForLocationUseCase
    }

    func viewDidLoad() {
        // Fetch weather for current location if any saved
        // If no previous location saved, present search screen
        fetchWeatherForLocationUseCase.execute("Auckland")
        setUseCaseDelegates()
    }

    func setUseCaseDelegates() {
        fetchWeatherForLocationUseCase.delegate = self
    }
}

extension WeatherViewModel: FetchWeatherForLocationUseDelegate {
    // MARK: - FetchWeatherForLocationUseDelegate
    func successWeatherResponseForLocation(weahter: Weather) {
        if let city = weahter.location?.city, let country = weahter.location?.country {
            delegate?.updateLocaleLabel(with: "\(city) - \(country)")
        }

        if let temperature = weahter.temperature?.temp.rounded() {
            delegate?.updateTemperatureLabel(with: "\(temperature)")
        }
    }

    func failedWeatherResponseForLocation(errorMessage: String) {

    }
}
