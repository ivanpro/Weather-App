//
//  WeatherClientInterface.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol WeatherClientInterface {
    func fetchWatherForLocation(_ location: String, onSuccess: ((_ json: JSONDictionary) -> Void)?, onError: HttpErrorClosure?)
    func fetchWatherForCoordinates(_ latitude: Double, longitude: Double, onSuccess: ((_ json: JSONDictionary) -> Void)?, onError: HttpErrorClosure?)
    func fetchIconForWeather(_ iconId: String, onSuccess: ((Data) -> Void)?, onError: HttpErrorClosure?)
}

extension WeatherClient {
    static let unknownErrorMessage = "Unknown error"

    struct Endpoints {
        static let weather: String = "https://api.openweathermap.org/data/2.5/weather?q=%@\(WeatherClient.apiKey)\(Units.metric)"
        static let icon: String = "https://openweathermap.org/img/wn/%@@2x.png"
        static let coordinate: String = "https://api.openweathermap.org/data/2.5/weather?lat=%.10f&lon=%.10f\(WeatherClient.apiKey)\(Units.metric)"
    }

    struct Units {
        static let metric = "&units=metric"
        static let imperial = "&units=imperial"
    }

    static let apiKey = "&appid=95d190a434083879a6398aafd54d9e73"
}
