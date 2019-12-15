//
//  StoreSearchedLocationUseCase.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation

protocol StoreSearchedLocationUseCaseInterface {
    func execute(_ input: String)
}

final class StoreSearchedLocationUseCase: UseCase<String>, StoreSearchedLocationUseCaseInterface {
    var persistence: PersistenceInterface

    init(persistence: PersistenceInterface = Persistence(defaults: UserDefaults.standard)) {
        self.persistence = persistence
    }

    override func execute(_ input: String) {
        persistence.addItem(input)
    }
}
