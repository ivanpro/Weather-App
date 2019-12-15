//
//  Persistence.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

private struct Keys {
    static let recent = "recent"
}

final class Persistence: PersistenceInterface {
    private let defaults: UserDefaultsInterface

    init(defaults: UserDefaultsInterface) {
        self.defaults = defaults
    }

    func addItem(_ value: String) {
        addString(value, to: Keys.recent)
    }

    func remove(_ index: Int) {
        removeItem(at: index, from: Keys.recent)
    }

    func removeItem(at index: Int, from key: String) {
        guard var array = defaults.array(forKey: key) else { return }
        array.remove(at: index)
        defaults.set(array, forKey: key)
    }

    func addString(_ value: String, to key: String) {
        var array = defaults.array(forKey: key) ?? [String]()
        array.append(value)
        defaults.set(array, forKey: key)
    }
}
