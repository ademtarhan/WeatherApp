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
    func navigateToEdit(with event: EventModel?)
    var view: HomeViewController! { get set }
    func navigateToAuth()
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
    func navigateToEdit(with event: EventModel?) {
        let next = viewControllerFactory.editViewConroller
        next.event = event
        push(next, from: view)
    }
    func navigateToAuth(){
        let next = viewControllerFactory.authViewController
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
