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

    lazy var weatherImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        return image
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
        view.addSubview(weatherImage)
    }

    func setConstraints() {
        setTemperatureLabelConstraints()
        setLocationLabelConstraints()
        setWeatherImage()
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

    func setWeatherImage() {
        weatherImage.backgroundColor = .yellow
        weatherImage.snp.makeConstraints { make in
            make.height.width.equalTo(100.0)
            make.trailingMargin.equalTo(-30.0)
            make.leading.greaterThanOrEqualTo(temperatureLabel.snp_trailingMargin)
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

    func updateLocaleLabel(with text: String) {
        locationLabel.text = text
    }

    func requestFailed(with text: String) {
        presentErrorAlert(text)
    }

    func updateWeatherIcon(with imageData: Data) {
        weatherImage.image = UIImage(data: imageData)
    }
}

extension WeatherViewController {
    // MARK: Utility
    func presentErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: UIAlertController.Style.alert)

        let tryAgainHandler: ((UIAlertAction) -> Void)? = { [weak self] _ in
            self?.viewModel.tryAgainPressed()
        }

        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: tryAgainHandler))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))

        self.present(alert, animated: true, completion: nil)
    }
}
