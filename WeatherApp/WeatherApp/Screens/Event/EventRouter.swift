//
//  EventRouter.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 30.11.2022.
//

import Foundation
import UIKit

protocol EventRouter: AnyObject {
    func navigateToHome()
    var view: EventViewController! { get set }
}

class EventRouterImpl: EventRouter {
    var view: EventViewController!

    let viewControllerFactory: ViewControllerFactory
    init(viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory
    }

    func navigateToHome() {
        let next = viewControllerFactory.homeViewController
        push(next, from: view)
    }
}

extension EventRouterImpl {
    func push<T, E>(_ view: T, from source: E?) {
        guard let source = source as? UIViewController,
              let destination = view as? UIViewController else { return }
        DispatchQueue.main.async {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
