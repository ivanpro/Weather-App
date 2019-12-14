//
//  CurrentUserLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 14/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import CoreLocation

protocol CurrentUserLocationUseCaseInterface {
    func execute() -> (() -> Void)?

    var delegate: CurrentUserLocationUseCaseDelegate? { get set }
}

protocol CurrentUserLocationUseCaseDelegate: AnyObject {
    func weatherForUserLocation(_ weather: Weather)
    func failedToAcquireUserLocation(errorMessage: String)
}

final class CurrentUserLocationUseCase: CurrentUserLocationUseCaseInterface {
    let locationWrapper: LocationInterface
    var fetchWeatherForCoordinateUseCase: FetchWeatherForCoordinateUseCaseInterface

    weak var delegate: CurrentUserLocationUseCaseDelegate?

    init(locationWrapper: LocationInterface = LocationWrapper(),
         fetchWeatherForCoordinateUseCase: FetchWeatherForCoordinateUseCaseInterface = FetchWeatherForCoordinateUseCase()) {
        self.locationWrapper = locationWrapper
        self.fetchWeatherForCoordinateUseCase = fetchWeatherForCoordinateUseCase
    }

    func execute() -> (() -> Void)? {
        return locationWrapper.getUserLocation { [weak self] locationResult in
            switch locationResult {
            case let .userLocation(longitude, latitude):
                self?.fetchWeatherForCoordinateUseCase.delegate = self
                self?.fetchWeatherForCoordinateUseCase.execute((latitude, longitude))
            case .appNotAuthorized:
                self?.delegate?.failedToAcquireUserLocation(errorMessage: "Let us know your location so we can show you pick-up locations nearby.")
            case .deviceLocationServicesDisabled:
                self?.delegate?.failedToAcquireUserLocation(errorMessage: "Please turn on your location services via settings so we can show you pick-up locations nearby.")
            case .error:
                self?.delegate?.failedToAcquireUserLocation(errorMessage: "Could not retrieve your location right now. Please try again later.")
            }
        }
    }
}

extension CurrentUserLocationUseCase: FetchWeatherForCoordinateUseCaseDelegate {
    func successWeatherResponseForLocation(_ weather: Weather) {
        delegate?.weatherForUserLocation(weather)
    }

    func failedWeatherResponseForLocation(_ errorMessage: String) {
        delegate?.failedToAcquireUserLocation(errorMessage: errorMessage)
    }
}
