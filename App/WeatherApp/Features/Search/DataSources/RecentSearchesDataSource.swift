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

    init(tableView: UITableView) {
        diffCalculator = SingleSectionTableViewDiffCalculator<String>(tableView: tableView)
        super.init()
        self.registerCells(for: tableView)
    }
}

extension RecentSearchesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diffCalculator.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard diffCalculator.rows.count > indexPath.row else { return UITableViewCell() }
        let recentLocation = diffCalculator.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.recentLocation)
        cell?.textLabel?.text = recentLocation
        cell?.textLabel?.font = UIFont(name: "Arial", size: 20.0)
        cell?.textLabel?.textColor = .black
        return cell ?? UITableViewCell()
    }
}

extension RecentSearchesDataSource: UITableViewDelegate {
    
}

extension RecentSearchesDataSource: SearchViewModelDataSourceDelegate {
    // MARK: - SearchViewModelDataSourceDelegate
    func reloadTableWithRecentLocations(_ locations: [String]) {
        diffCalculator.rows = locations
    }
}

extension RecentSearchesDataSource {
    // MARK: - Utility

    private func registerCells(for tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.recentLocation)
    }
}
