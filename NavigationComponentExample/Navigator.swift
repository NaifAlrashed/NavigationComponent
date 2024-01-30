//
//  NavigationComponent.swift
//  NavigationComponentExample
//
//  Created by Naif Alrashed on 28/01/2024.
//

import UIKit

enum NavigationStyle: String {
    case navigation
    case modal
}

public class RouteCollection {
    private var routes: [String: any Route] = [:]
    
    @discardableResult
    public func register(_ routes: any Route...) -> RouteCollection {
        routes.forEach { route in
            self.routes[route.id] = route
        }
        return self
    }
    
    subscript(path: String) -> (any Route)? {
        routes[path]
    }
}

public final class Router {
    private let routeCollection: RouteCollection
    private let window: UIWindow
    
    public init(window: UIWindow, routeCollection: RouteCollection) {
        self.window = window
        self.routeCollection = routeCollection
    }
    
    public func route(to params: [String: Any], from viewController: UIViewController?) {
        guard let path = params["path"] as? String,
              let navigation = params["navigationStyle"] as? String,
              let navigationStyle = NavigationStyle(rawValue: navigation)
        else {
            logNavigationInputError(in: params)
            return
        }
        guard let route = routeCollection[path] else {
            logNavigationRouteError(in: path, from: params)
            return
        }
        if let json = try? JSONSerialization.data(withJSONObject: params), // we can make a custom decoder for [String: Any] types. This is just to get it up and running
           let page = makePage(from: route, using: json) {
            navigate(to: page, from: viewController, with: navigationStyle)
        } else {
            logNavigationRouteError(in: route.id, from: params)
        }
        
        logPageNotFound(in: params)
    }
    
    private func navigate(
        to page: UIViewController,
        from fromViewController: UIViewController?,
        with navigationStyle: NavigationStyle
    ) {
        guard let fromViewController else {
            addFirstPage(withViewController: UINavigationController(rootViewController: page))
            return
        }
        switch navigationStyle {
        case .navigation:
            fromViewController.show(page, sender: nil)
        case .modal:
            let navigationController = UINavigationController(rootViewController: page)
            fromViewController.present(navigationController, animated: true)
        }
    }
    
    private func addFirstPage(withViewController viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    private func logNavigationInputError(in params: [String: Any]) {
        // log page not found
    }
    
    private func logNavigationRouteError(in route: String, from params: [String: Any]) {
        // log errors that are related to missing data from a given page params
    }
    
    private func logPageNotFound(in: [String: Any]) {
        
    }
    
    private func makePage<R: Route>(from route: R, using data: Data) -> UIViewController? {
        guard let params = try? JSONDecoder().decode(R.Params.self, from: data) else { return nil }
        return route.makePage(from: params)
    }
}

public protocol Route: Identifiable where ID == String {
    associatedtype Params: Decodable
    
    func makePage(from params: Params) -> UIViewController
}
