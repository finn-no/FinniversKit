//
//  AppDelegate.swift
//  Project
//
//  Created by Nuñez, Elvis on 31/08/2017.
//  Copyright © 2017 FINN AS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        let marketViewController = MarketViewController()

        tabBarController.setViewControllers([marketViewController], animated: false)

        return tabBarController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
}
