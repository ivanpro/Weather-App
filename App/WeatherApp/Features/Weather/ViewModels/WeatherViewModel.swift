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
    func tryAgainPressed()
    func searchPressed()

    var delegate: WeatherViewModelDelegate? { get set }
    var coordinatorDelegate: WeatherCoordinatorDelegate? { get set }
}

protocol WeatherViewModelDelegate: AnyObject {
    func updateTemperatureLabel(with text: String)
    func updateLocaleLabel(with text: String)
    func requestFailed(with text: String)

    func updateWeatherIcon(with imageData: Data)
}

protocol WeatherCoordinatorDelegate: AnyObject {
    func presentSearchScreen()
}

final class WeatherViewModel: WeatherViewModelInterface {
    weak var delegate: WeatherViewModelDelegate?
    weak var coordinatorDelegate: WeatherCoordinatorDelegate?

    var fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface
    var getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface

    convenience init() {
        self.init(fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCase(),
                  getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCase())
    }

    init(fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface,
         getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface) {
        self.fetchLastLocationWeatherUseCase = fetchLastLocationWeatherUseCase
        self.getWeatherIconForLocationUseCase = getWeatherIconForLocationUseCase
    }

    func viewDidLoad() {
        // Fetch weather for current location if any saved
        // If no previous location saved, present search screen
        setUseCaseDelegates()
        fetchLastLocationWeatherUseCase.execute()
    }

    func setUseCaseDelegates() {
        fetchLastLocationWeatherUseCase.delegate = self
        getWeatherIconForLocationUseCase.delegate = self
    }
}

extension WeatherViewModel {
    // MARK: - ViewController Actions
    func tryAgainPressed() {
        fetchLastLocationWeatherUseCase.execute()
    }

    func searchPressed() {
        coordinatorDelegate?.presentSearchScreen()
    }
}

extension WeatherViewModel: FetchLastLocationWeatherUseCaseDelegate {
    // MARK: - FetchLastLocationWeatherUseCaseDelegate
    func successWeatherResponseForLocation(weahter: Weather) {
        if let icon = weahter.detail?.icon {
            getWeatherIconForLocationUseCase.execute(icon)
        }

        if let city = weahter.location?.city, let country = weahter.location?.country {
            delegate?.updateLocaleLabel(with: "\(city) - \(country)")
        }

        if let temperature = weahter.temperature?.temp.rounded() {
            delegate?.updateTemperatureLabel(with: "\(temperature)")
        }
    }

    func failedWeatherResponseForLocation(errorMessage: String) {
        delegate?.requestFailed(with: errorMessage)
    }
}

extension WeatherViewModel: GetWeatherIconForLocationUseCaseDelegate {
    // MARK: - GetWeatherIconForLocationUseCaseDelegate
    func successResponseForIcon(_ imageData: Data) {
        delegate?.updateWeatherIcon(with: imageData)
    }

    func failedResponseForIcon(_ errorMessage: String) {}
}
