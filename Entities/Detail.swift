//
//  Details.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

struct Detail: Equatable {
    let description: String
    let icon: String
    let main: String

    init?(with dictionary: JSONDictionary) {
        let mainDict = dictionary.array(forKey: "weather")?.first as? JSONDictionary
        guard let description = mainDict?.string(forKey: "description") else { return nil }
        guard let icon = mainDict?.string(forKey: "icon") else { return nil }
        guard let main = mainDict?.string(forKey: "main") else { return nil }

        self.description = description
        self.icon = icon
        self.main = main
    }
}
