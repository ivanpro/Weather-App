//
//  Fixture.swift
//  WeatherAppTests
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

class Fixture {
    static func toDictionary(_ fixture: String) -> [String: Any] {
        if let file = Bundle.main.url(forResource: fixture, withExtension: ".fixture") {
            do {
                let data = try Data(contentsOf: file, options: .alwaysMapped)
                return try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as! [String: Any]
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Invalid path for \(fixture)")
        }
    }
}
