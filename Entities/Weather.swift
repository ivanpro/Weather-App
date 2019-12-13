//
//  Weather.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

struct Weather: Equatable {
    let detail: Detail?
    let location: Location?
    let temperature: Temperature?
    let wind: Wind?

    init?(with dictionary: JSONDictionary) {
        self.detail = Detail(with: dictionary)
        self.location = Location(with: dictionary)
        self.temperature = Temperature(with: dictionary)
        self.wind = Wind(with: dictionary)
    }
}
