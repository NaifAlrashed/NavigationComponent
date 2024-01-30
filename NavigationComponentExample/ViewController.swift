//
//  ViewController.swift
//  NavigationComponentExample
//
//  Created by Naif Alrashed on 28/01/2024.
//

import UIKit

class FirstViewController: UIViewController {
    
    let shopID: String
    
    init(shopID: String) {
        self.shopID = shopID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let label = makeLabel()
        let button = makeButton()
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        view.addConstraints([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }


    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.text = shopID
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeButton() -> UIButton {
//        presenting the same view but modally
        let shouldPresentModally = Bool.random()
        let navigationParams: [String: Any] = [
            "path": "first",
            "navigationStyle": shouldPresentModally ? "modal": "navigation",
            "userID": "ufew2983rb"
        ]
        let button = UIButton(primaryAction: UIAction(title: "modal present") { [weak self] _ in
            guard let self else { return }
            navigator.route(to: navigationParams, from: self)
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

class MenuViewController: UIViewController {
    let shopID: String
    
    init(shopID: String) {
        self.shopID = shopID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct MenuParameters: Decodable {
    let shopID: String
}

struct MenuRoute: Route {
    let id = "first"
    
    func makePage(from params: MenuParameters) -> UIViewController {
        FirstViewController(shopID: params.shopID)
    }
}
