//
//  AuthRouter.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 30.11.2022.
//

import Foundation
import UIKit

protocol AuthRouter: AnyObject {
    func navigateToHome()
    var view: AuthViewController! { get set }
}

class AuthRouterImpl: AuthRouter {
    var view: AuthViewController!
    let viewControllerFactory: ViewControllerFactory!
    init(viewControllerFactory: ViewControllerFactory!) {
        self.viewControllerFactory = viewControllerFactory
    }

    func navigateToHome() {
        let next = viewControllerFactory.homeViewController
        push(next, from: view)
    }
}

extension AuthRouterImpl {
    func push<T, E>(_ view: T, from source: E?) {
        guard let source = source as? UIViewController,
              let destination = view as? UIViewController else { return }
        DispatchQueue.main.async {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
}
