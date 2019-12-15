//
//  RemoveStoredLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol RemoveStoredLocationUseCaseInterface: AutoMockable {
    func execute(_ input: String)
}

final class RemoveStoredLocationUseCase: UseCase<String>, RemoveStoredLocationUseCaseInterface {
    var persistence: PersistenceInterface

    init(persistence: PersistenceInterface = Persistence(defaults: UserDefaults.standard)) {
        self.persistence = persistence
    }

    override func execute(_ input: String) {
        return persistence.removeItem(input)
    }
}
