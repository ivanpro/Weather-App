//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol WeatherViewModelInterface {
    func viewDidLoad()

    var delegate: WeatherViewModelDelegate? { get set }
}

protocol WeatherViewModelDelegate: class {
    func updateTemperatureLabel(with text: String)
}

final class WeatherViewModel: WeatherViewModelInterface {
    weak var delegate: WeatherViewModelDelegate?

    func viewDidLoad() {
        // Fetch weather for current location if any saved
        // If no previous location saved, present search screen
        delegate?.updateTemperatureLabel(with: "30ºC")
    }
}
