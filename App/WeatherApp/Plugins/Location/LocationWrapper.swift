//
//  LocationWrapper.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 14/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import CoreLocation

enum UserLocationResult: Equatable {
    case deviceLocationServicesDisabled
    case appNotAuthorized
    case userLocation(longitude: Double, latitude: Double)
    case error
}

protocol LocationInterface: AutoMockable {
    typealias CancelHandler = () -> Void
    func getUserLocation(onCompletion: @escaping (UserLocationResult) -> Void) -> CancelHandler?
}

final class LocationWrapper: NSObject, LocationInterface {
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        return locationManager
    }()

    private var hasRequestedLocation = false
    private var onCompletion: ((UserLocationResult) -> Void)?

    func getUserLocation(onCompletion: @escaping (UserLocationResult) -> Void) -> CancelHandler? {
        guard CLLocationManager.locationServicesEnabled() else {
            onCompletion(.deviceLocationServicesDisabled)
            return nil
        }

        hasRequestedLocation = true
        self.onCompletion = onCompletion
        return retrieveUserLocation()
    }

    private func retrieveUserLocation() -> CancelHandler? {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        default:
            notAuthorizedErrorIfNeeded()
            return nil
        }
        return { [weak self] in
            guard let self = self else { return }
            self.locationManager.stopUpdatingLocation()
        }
    }

    private func notAuthorizedErrorIfNeeded() {
        if hasRequestedLocation {
            unauthorizedError()
            hasRequestedLocation = false
        }
    }

    private func locationError() {
        onCompletion?(.error)
        onCompletion = nil
    }

    private func requestLocation() {
        if hasRequestedLocation {
            locationManager.requestLocation()
            hasRequestedLocation = false
        }
    }

    private func unauthorizedError() {
        onCompletion?(.appNotAuthorized)
        onCompletion = nil
    }
}

extension LocationWrapper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            unauthorizedError()
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        @unknown default:
            locationError()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            onCompletion?(.userLocation(longitude: longitude, latitude: latitude))
            onCompletion = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError()
    }
}
