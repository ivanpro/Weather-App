//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol WeatherViewControllerInterface {}

private struct Dimensions {
    static let margin: CGFloat = 16.0
}

final class WeatherViewController: UIViewController, WeatherViewControllerInterface {
    var viewModel: WeatherViewModelInterface

    lazy var locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 20.0)
        label.textColor = .black
        label.text = "Sydney, NSW"
        return label
    }()

    lazy var temperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 30.0)
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
        view.addSubview(locationLabel)
        view.addSubview(temperatureLabel)
    }

    func setConstraints() {
        setTemperatureLabelConstraints()
        setLocationLabelConstraints()
    }

    func setLocationLabelConstraints() {
        locationLabel.backgroundColor = .lightGray
        locationLabel.snp.makeConstraints { make in
            make.height.equalTo(60.0)
            make.topMargin.equalTo(Dimensions.margin)
            make.leadingMargin.equalTo(Dimensions.margin)
            make.trailingMargin.equalTo(-Dimensions.margin)
        }
    }

    func setTemperatureLabelConstraints() {
        temperatureLabel.backgroundColor = .blue
        temperatureLabel.snp.makeConstraints { make -> Void in
            make.height.equalTo(100.0)
            make.width.equalTo(100.0)
            make.leadingMargin.equalTo(30.0)
            make.top.equalTo(locationLabel.snp_bottomMargin).offset(Dimensions.margin)
        }
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
