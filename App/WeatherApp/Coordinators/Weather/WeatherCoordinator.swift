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
        viewController.title = "Gumtree Weather"
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension WeatherCoordinator: WeatherCoordinatorDelegate {
    func presentSearchScreen() {
        let viewModel = SearchViewModel()
        viewModel.coordinatorDelegate = self
        let coordinator = SearchCoordinator(navigationController: navigationController, viewModel: viewModel)
        coordinator.start()

        children[.search] = coordinator
    }
}

extension WeatherCoordinator: SearchCoordinatorDelegate {
    func fetchWeatherForLocationSuccessful(_ weather: Weather) {
        viewModel.loadWeather(weather)
        navigationController.popViewController(animated: true)
        children[.search] = nil
    }

    func fetchWeatherForLocationFailed() {

    }
}
