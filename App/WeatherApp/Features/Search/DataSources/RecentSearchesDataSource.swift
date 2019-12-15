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

protocol RecentSearchesDataSourceDelegate: AnyObject {
    func didSelectLocation(_ location: String)
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
