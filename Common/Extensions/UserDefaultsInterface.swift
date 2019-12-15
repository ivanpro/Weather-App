//
//  UserDefaultsInterface.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

public protocol UserDefaultsInterface: AutoMockable {
    func set(_ value: Any?, forKey defaultName: String)
    func array(forKey defaultName: String) -> [Any]?
}

extension UserDefaults: UserDefaultsInterface {}
