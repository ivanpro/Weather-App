//
//  GetWeatherIconForLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit

protocol GetWeatherIconForLocationUseCaseInterface {}

final class GetWeatherIconForLocationUseCase: UseCase<String, UIImage>, GetWeatherIconForLocationUseCaseInterface {
    let weatherRepository: WeatherRepositoryInterface

    init(weatherRepository: WeatherRepositoryInterface = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    override func execute(_ input: String) -> UIImage {
        // Ask client to fetch result
        return UIImage()
    }
}
