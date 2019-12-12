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
}

final class WeatherViewModel: WeatherViewModelInterface {
    weak var delegate: WeatherViewModelDelegate?

    let fetchWeatherForLocationUseCase: FetchWeatherForLocationUseCaseInterface
    let fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface
    let getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface

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
        delegate?.updateTemperatureLabel(with: "30ºC")
    }
}
