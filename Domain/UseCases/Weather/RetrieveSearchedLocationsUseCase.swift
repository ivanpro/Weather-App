//
//  RetrieveSearchedLocationsUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol RetrieveSearchedLocationsUseCaseInterface: AutoMockable {
    func execute() -> [String]
}

final class RetrieveSearchedLocationsUseCase: VoidUseCase<[String]>, RetrieveSearchedLocationsUseCaseInterface {
    var persistence: PersistenceInterface

    init(persistence: PersistenceInterface = Persistence(defaults: UserDefaults.standard)) {
        self.persistence = persistence
    }

    override func execute() -> [String] {
        return persistence.allItems()
    }
}
