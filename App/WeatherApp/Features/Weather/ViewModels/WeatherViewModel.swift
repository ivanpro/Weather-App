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
        delegate?.updateTemperatureLabel(with: "Hello Gumtree")
    }
}
