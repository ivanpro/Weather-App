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

final class WeatherViewController: UIViewController, WeatherViewControllerInterface {
    var viewModel: WeatherViewModelInterface

    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "weather_background.png"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 20.0)
        label.textColor = .black
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
        image.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        image.layer.cornerRadius = 30.0
        image.layer.masksToBounds = true
        return image
    }()

    lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPressed))
        button.tintColor = Theme.color
        return button
    }()

    lazy var gpsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "gps_icon.pdf"), style: .plain, target: self, action: #selector(gpsPressed))
        button.tintColor = Theme.color
        return button
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = Theme.color
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
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

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.viewDidDisappear()
        super.viewDidDisappear(animated)
    }
}

extension WeatherViewController {
    // MARK: - UI Setup
    func buildUI() {
        view.backgroundColor = UIColor(red: (73/255), green: (183/255), blue: (232/255), alpha: 1.0)
        addSubviews()
        setConstraints()
    }

    func addSubviews() {
        navigationItem.setRightBarButton(searchButton, animated: false)
        navigationItem.setLeftBarButton(gpsButton, animated: false)
        view.addSubview(backgroundImageView)
        view.addSubview(locationLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(weatherImage)
        view.addSubview(activityIndicator)
    }

    func setConstraints() {
        setBackgroundImageConstraints()
        setTemperatureLabelConstraints()
        setLocationLabelConstraints()
        setWeatherImageConstraints()
        setActivityIndicatorConstraints()
    }

    func setBackgroundImageConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(view)
        }
    }

    func setLocationLabelConstraints() {
        locationLabel.snp.makeConstraints { make in
            make.height.equalTo(60.0)
            make.topMargin.equalTo(Dimensions.margin)
            make.leadingMargin.equalTo(Dimensions.margin)
            make.trailingMargin.equalTo(-Dimensions.margin)
        }
    }

    func setTemperatureLabelConstraints() {
        temperatureLabel.snp.makeConstraints { make -> Void in
            make.height.equalTo(100.0)
            make.width.equalTo(150.0)
            make.leadingMargin.equalTo(30.0)
            make.top.equalTo(locationLabel.snp_bottomMargin).offset(Dimensions.margin)
        }
    }

    func setWeatherImageConstraints() {
        weatherImage.snp.makeConstraints { make in
            make.height.width.equalTo(100.0)
            make.trailingMargin.equalTo(-30.0)
            make.leading.greaterThanOrEqualTo(temperatureLabel.snp_trailingMargin)
            make.top.equalTo(locationLabel.snp_bottomMargin).offset(Dimensions.margin)
        }
    }

    func setActivityIndicatorConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
}

extension WeatherViewController {
    // MARK: - UI Actions

    @objc
    func searchPressed() {
        viewModel.searchPressed()
    }

    @objc
    func gpsPressed() {
        viewModel.gpsPressed()
    }

    func startAnimatingIndicator() {
        activityIndicator.startAnimating()
    }

    func stopAnimatingIndicator() {
        activityIndicator.stopAnimating()
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    // MARK: - WeatherViewModelDelegate
    func updateTemperatureLabel(with text: String) {
        temperatureLabel.text = text
    }

    func updateLocaleLabel(with text: String) {
        locationLabel.text = text
    }

    func updateWeatherIcon(with imageData: Data) {
        weatherImage.image = UIImage(data: imageData)
    }

    func requestFailed(with text: String) {
        presentErrorAlert(text, withHandler: true)
    }

    func failedToLocateUser(_ errorMessage: String) {
        presentErrorAlert(errorMessage)
    }
}

extension WeatherViewController {
    // MARK: Utility
    func presentErrorAlert(_ message: String, withHandler: Bool = false) {
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: UIAlertController.Style.alert)

        if withHandler {
            let tryAgainHandler: ((UIAlertAction) -> Void)? = { [weak self] _ in
                self?.viewModel.tryAgainPressed()
            }

            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: tryAgainHandler))
        }

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel))

        present(alert, animated: true, completion: nil)
    }
}
