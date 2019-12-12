//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit

final class WeatherViewController: UIViewController {
    let viewModel: WeatherViewModelInterface
    init(viewModel: WeatherViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        viewModel.viewDidLoad()
    }
}

extension WeatherViewController {
    // MARK: - Build UI
    func buildUI() {
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 100, y: 300, width: 400, height: 40))
        label.text = "Hello Gumtree"
        label.textColor = .black
        view.addSubview(label)
    }
}
