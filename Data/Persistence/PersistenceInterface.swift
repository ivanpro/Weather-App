//
//  PersistenceInterface.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

/// By following the rules in here we are making sure that we can update our persistence
/// layer to change without breaking the whole app. This will allows us to use CoreData or
/// Keychain later on if we want to

protocol PersistenceInterface {
    func addItem(_ value: String)
    func remove(_ index: Int)
}
