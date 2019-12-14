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

    func loadWeather(_ weather: Weather)
    func searchFailed(_ errorMessage: String)

    var delegate: WeatherViewModelDelegate? { get set }
    var coordinatorDelegate: WeatherCoordinatorDelegate? { get set }
}

protocol WeatherViewModelDelegate: AnyObject {
    func updateTemperatureLabel(with text: String)
    func updateLocaleLabel(with text: String)
    func requestFailed(with text: String)

    func startAnimatingIndicator()
    func stopAnimatingIndicator()

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

    init(fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface = FetchLastLocationWeatherUseCase(),
         getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface = GetWeatherIconForLocationUseCase()) {
        self.fetchLastLocationWeatherUseCase = fetchLastLocationWeatherUseCase
        self.getWeatherIconForLocationUseCase = getWeatherIconForLocationUseCase
    }

    func viewDidLoad() {
        setUseCaseDelegates()
        requestUseCase()
    }

    func setUseCaseDelegates() {
        fetchLastLocationWeatherUseCase.delegate = self
        getWeatherIconForLocationUseCase.delegate = self
    }
}

extension WeatherViewModel {
    // MARK: - Helper
    func requestUseCase() {
        guard fetchLastLocationWeatherUseCase.execute() == true else {
            delegate?.stopAnimatingIndicator()
            coordinatorDelegate?.presentSearchScreen()
            return
        }

        delegate?.startAnimatingIndicator()
    }
}

extension WeatherViewModel {
    // MARK: - Coordinator Actions
    func loadWeather(_ weather: Weather) {
        delegate?.stopAnimatingIndicator()
        successWeatherResponseForLocation(weather: weather)
    }

    func searchFailed(_ errorMessage: String) {
        delegate?.stopAnimatingIndicator()
        delegate?.requestFailed(with: errorMessage)
    }
}

extension WeatherViewModel {
    // MARK: - ViewController Actions
    func tryAgainPressed() {
        requestUseCase()
    }

    func searchPressed() {
        coordinatorDelegate?.presentSearchScreen()
    }
}

extension WeatherViewModel: FetchLastLocationWeatherUseCaseDelegate {
    // MARK: - FetchLastLocationWeatherUseCaseDelegate
    func successWeatherResponseForLocation(weather weahter: Weather) {
        delegate?.stopAnimatingIndicator()

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
