//
//  Dictionary.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 13/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

public extension Dictionary {
    func string(forKey key: String) -> String? {
        guard let key = key as? Key else { return nil }
        guard let value = self[key] as? String else { return nil }
        return value
    }

    func float(forKey key: String) -> Float? {
        return number(forKey: key)?.floatValue
    }

    func int(forKey key: String) -> Int? {
        return number(forKey: key)?.intValue
    }

    func number(forKey key: String) -> NSNumber? {
        guard let key = key as? Key else { return nil }
        return self[key] as? NSNumber
    }

    func dictionary(forKey key: String) -> JSONDictionary? {
        guard let key = key as? Key else { return nil }
        guard let value = self[key] as? JSONDictionary else { return nil }
        return value
    }

    func array(forKey key: String) -> [Any]? {
        guard let key = key as? Key else { return nil }
        guard let value = self[key] as? [Any]? else { return nil }
        return value
    }
}
