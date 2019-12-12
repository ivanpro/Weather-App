//
//  UseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

class UseCase<Input> {
    func execute(_ input: Input) {
        fatalError("this should be overridden")
    }
}
