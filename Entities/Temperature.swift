//
//  Weather.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

struct Temperature: Equatable {
    let humidity: Int
    let pressure: Int
    let temp: Float
    let tempMax: Float
    let tempMin: Float

    init?(with dictionary: JSONDictionary) {
        let mainDict = dictionary["main"] as? JSONDictionary
        guard let temp_max = mainDict?.float(forKey: "temp_max") else { return nil }
        guard let temp_min = mainDict?.float(forKey: "temp_min") else { return nil }
        guard let temp = mainDict?.float(forKey: "temp") else { return nil }
        guard let humidity = mainDict?.int(forKey: "humidity") else { return nil }
        guard let pressure = mainDict?.int(forKey: "pressure") else { return nil }

        self.humidity = humidity
        self.pressure = pressure
        self.temp = temp
        self.tempMax = temp_max
        self.tempMin = temp_min
    }
}
