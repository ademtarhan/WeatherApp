//
//  HomeRouter.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 13.10.2022.
//

import Foundation
import UIKit

protocol HomeRouter: AnyObject {
    func navigateToEvent()
    var view: HomeViewController! { get set }
}

class HomeRouterImpl: HomeRouter {
    var view: HomeViewController!

    let viewControllerFactory: ViewControllerFactory!

    init(viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory
    }

    func navigateToEvent() {
        let next = viewControllerFactory.eventViewController
        push(next, from: view)
    }
}

extension HomeRouterImpl {
    func push<T, E>(_ view: T, from source: E?) {
        guard let source = source as? UIViewController,
              let destination = view as? UIViewController else { return }
        DispatchQueue.main.async {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
