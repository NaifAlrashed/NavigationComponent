//
//  AppDelegate.swift
//  NavigationComponentExample
//
//  Created by Naif Alrashed on 28/01/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let params: [String: Any] = [
            "path": "first",
            "navigationStyle": "modal",
            "userID": "ufew2983rb"
        ]
        navigator.route(to: params, from: nil)
        return true
    }
}

let navigator = {
    let routes = RouteCollection()
    routes.register(MenuRoute())
    return Router(window: UIWindow(), routeCollection: routes)
}()
