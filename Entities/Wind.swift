//
//  Wind.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

struct Wind: Equatable {
    let degree: Int
    let speed: Float

    init?(with dictionary: JSONDictionary) {
        let mainDict = dictionary["wind"] as? JSONDictionary
        guard let degree = mainDict?.int(forKey: "deg") else { return nil }
        guard let speed = mainDict?.float(forKey: "speed") else { return nil }

        self.degree = degree
        self.speed = speed
    }
}
