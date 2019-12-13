//
//  Location.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

struct Location: Equatable {
    let country: String
    let city: String

    init?(with dictionary: JSONDictionary) {
        let sysDict = dictionary["sys"] as? JSONDictionary
        guard let country = sysDict?.string(forKey: "country") else { return nil }
        guard let city = dictionary.string(forKey: "name") else { return nil }

        self.country = country
        self.city = city
    }
}
