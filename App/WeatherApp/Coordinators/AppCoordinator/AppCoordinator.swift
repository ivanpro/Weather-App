//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit

protocol AppCoordinatorInterface: Coordinator, AutoMockable {}

enum AppCoordinatorChild: Equatable {
    case map
}

final class AppCoordinator: AppCoordinatorInterface {
    var children = [AppCoordinatorChild: Coordinator]()
    var window: UIWindow
    var navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func start() {
        let viewModel = WeatherViewModel()
        let coordinator = WeatherCoordinator(navigationController: navigationController, viewModel: viewModel)
        children[.map] = coordinator
        coordinator.start()
    }
}
