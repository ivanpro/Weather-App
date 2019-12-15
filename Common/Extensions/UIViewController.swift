//
//  UIViewController.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 14/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    struct Dimensions {
        static let margin: CGFloat = 16.0
        static let doubleMargim: CGFloat = margin * 2
    }

    struct Theme {
        static let color: UIColor = .darkGray
        static let font: UIFont? = UIFont(name: "Arial", size: 20.0)
    }
}
