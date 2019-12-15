//
//  RecentSearchesDataSource.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 15/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import Dwifft
import UIKit

private struct CellIdentifiers {
    static let recentLocation = "RecentLocation"
}

final class RecentSearchesDataSource: NSObject {
    private var diffCalculator: SingleSectionTableViewDiffCalculator<String>
    private var viewModel: SearchViewModelDataSourceInterface

    init(viewModel: SearchViewModelDataSourceInterface = SearchViewModel(),
         tableView: UITableView) {
        self.diffCalculator = SingleSectionTableViewDiffCalculator<String>(tableView: tableView)
        self.viewModel = viewModel
        super.init()
        self.registerCells(for: tableView)
    }
}

extension RecentSearchesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diffCalculator.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let locationName = location(for: indexPath.row) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.recentLocation)
        cell?.textLabel?.text = locationName
        cell?.textLabel?.font = UIFont(name: "Arial", size: 20.0)
        cell?.textLabel?.textColor = .black
        return cell ?? UITableViewCell()
    }
}

extension RecentSearchesDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let locationName = location(for: indexPath.row) else { return }
        viewModel.didSelectLocation(locationName)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _,_, completionHandler in
            guard let locationName = self?.location(for: indexPath.row) else { return }
            self?.viewModel.didRemoveLocation(locationName)
            return completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard location(for: indexPath.row) != nil else { return false }
        return true
    }
}

extension RecentSearchesDataSource: SearchViewModelDataSourceDelegate {
    // MARK: - SearchViewModelDataSourceDelegate
    func reloadTableWithRecentLocations(_ locations: [String]) {
        diffCalculator.rows = locations
    }
}

extension RecentSearchesDataSource {
    // MARK: - Utility

    private func location(for index: Int) -> String? {
        guard diffCalculator.rows.count > index else { return nil }
        return diffCalculator.rows[index]
    }

    private func registerCells(for tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.recentLocation)
    }
}
