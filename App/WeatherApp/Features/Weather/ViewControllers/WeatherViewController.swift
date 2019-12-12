//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherViewControllerInterface {}

final class WeatherViewController: UIViewController, WeatherViewControllerInterface {
    var viewModel: WeatherViewModelInterface

    lazy var temperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        return label
    }()

    init(viewModel: WeatherViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        buildUI()
        viewModel.viewDidLoad()
    }
}

extension WeatherViewController {
    // MARK: - UI Setup
    func buildUI() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }

    func addSubviews() {
        view.addSubview(temperatureLabel)
    }

    func setConstraints() {
        setLabelConstraints()
    }

    func setLabelConstraints() {
        temperatureLabel.frame = CGRect(x: 100, y: 300, width: 400, height: 40)
    }
}

extension WeatherViewController {
    // MARK: - UI Actions
}

extension WeatherViewController: WeatherViewModelDelegate {
    // MARK: - WeatherViewModelDelegate
    func updateTemperatureLabel(with text: String) {
        temperatureLabel.text = text
    }
}
