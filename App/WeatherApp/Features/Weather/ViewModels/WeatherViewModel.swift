//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherViewModelInterface: AutoMockable {
    func viewDidLoad()
    func viewDidDisappear()
    func tryAgainPressed()
    func searchPressed()
    func gpsPressed()

    func loadWeather(_ weather: Weather)
    func searchFailed(_ errorMessage: String)

    var delegate: WeatherViewModelDelegate? { get set }
    var coordinatorDelegate: WeatherCoordinatorDelegate? { get set }
}

protocol WeatherViewModelDelegate: AnyObject, AutoMockable {
    func updateTemperatureLabel(with text: String)
    func updateLocaleLabel(with text: String)
    func requestFailed(with text: String)
    func failedToLocateUser(_ errorMessage: String)

    func startAnimatingIndicator()
    func stopAnimatingIndicator()

    func updateWeatherIcon(with imageData: Data)
}

protocol WeatherCoordinatorDelegate: AnyObject, AutoMockable {
    func presentSearchScreen()
}

final class WeatherViewModel: WeatherViewModelInterface {
    weak var delegate: WeatherViewModelDelegate?
    weak var coordinatorDelegate: WeatherCoordinatorDelegate?

    var cancelLocationHandler: (() -> Void)?

    var fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface
    var getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface
    var currentUserLocationUseCase: CurrentUserLocationUseCaseInterface

    init(fetchLastLocationWeatherUseCase: FetchLastLocationWeatherUseCaseInterface = FetchLastLocationWeatherUseCase(),
         getWeatherIconForLocationUseCase: GetWeatherIconForLocationUseCaseInterface = GetWeatherIconForLocationUseCase(),
         currentUserLocationUseCase: CurrentUserLocationUseCaseInterface = CurrentUserLocationUseCase()) {
        self.fetchLastLocationWeatherUseCase = fetchLastLocationWeatherUseCase
        self.getWeatherIconForLocationUseCase = getWeatherIconForLocationUseCase
        self.currentUserLocationUseCase = currentUserLocationUseCase
    }

    func viewDidLoad() {
        setUseCaseDelegates()
        requestUseCase()
    }

    func viewDidDisappear() {
        cancelLocationHandler?()
    }

    func setUseCaseDelegates() {
        fetchLastLocationWeatherUseCase.delegate = self
        getWeatherIconForLocationUseCase.delegate = self
        currentUserLocationUseCase.delegate = self
    }
}

extension WeatherViewModel {
    // MARK: - Helper
    func requestUseCase(openSearch: Bool = false) {
        guard fetchLastLocationWeatherUseCase.execute() == true else {
            delegate?.stopAnimatingIndicator()
            if openSearch {
                coordinatorDelegate?.presentSearchScreen()
            }
            return
        }

        delegate?.startAnimatingIndicator()
    }
}

extension WeatherViewModel {
    // MARK: - Coordinator Actions
    func loadWeather(_ weather: Weather) {
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
        requestUseCase(openSearch: true)
    }

    func searchPressed() {
        coordinatorDelegate?.presentSearchScreen()
    }

    func gpsPressed() {
        delegate?.startAnimatingIndicator()
        cancelLocationHandler = currentUserLocationUseCase.execute()
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

    func failedResponseForIcon(_ errorMessage: String) {
        delegate?.requestFailed(with: errorMessage)
    }
}

extension WeatherViewModel: CurrentUserLocationUseCaseDelegate {
    func weatherForUserLocation(_ weather: Weather) {
        loadWeather(weather)
    }

    func failedToAcquireUserLocation(errorMessage: String) {
        delegate?.failedToLocateUser(errorMessage)
    }
}
