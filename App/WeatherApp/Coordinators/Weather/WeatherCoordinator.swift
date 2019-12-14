//
//  WeatherCoordinator.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherCoordinatorInterface: Coordinator {}

enum WeatherCoordinatorChild: Equatable {
    case search
    case recent
}

final class WeatherCoordinator: AppCoordinatorInterface {
    var children = [WeatherCoordinatorChild: Coordinator]()
    var navigationController: UINavigationController
    var viewModel: WeatherViewModelInterface

    init(navigationController: UINavigationController, viewModel: WeatherViewModelInterface) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        viewModel.coordinatorDelegate = self
        let viewController = WeatherViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension WeatherCoordinator: WeatherCoordinatorDelegate {
    func presentSearchScreen() {
        // Create serach cooridnator and start it
        let viewModel = SearchViewModel()
        let coordinator = SearchCoordinator(navigationController: navigationController, viewModel: viewModel)
        coordinator.start()

        children[.search] = coordinator
    }
}
