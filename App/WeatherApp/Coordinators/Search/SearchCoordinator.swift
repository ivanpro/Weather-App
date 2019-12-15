//
//  SearchCoordinator.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 14/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit

protocol SearchCoordinatorInterface: Coordinator, AutoMockable {}

final class SearchCoordinator: SearchCoordinatorInterface {
    var navigationController: UINavigationController
    var viewModel: SearchViewModelInterface

    init(navigationController: UINavigationController, viewModel: SearchViewModelInterface) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let viewController = SearchViewController(viewModel: viewModel)
        viewController.title = "Search"
        navigationController.pushViewController(viewController, animated: true)
    }
}
