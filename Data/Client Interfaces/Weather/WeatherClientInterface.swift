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
}
