//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 12/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 100, y: 300, width: 400, height: 40))
        label.text = "Hello Gumtree"
        label.textColor = .black
        vc.view.addSubview(label)

        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        return true
    }
}

