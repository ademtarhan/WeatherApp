//
//  EditRouter.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 14.12.2022.
//

import Foundation
import UIKit

protocol EditRouter: AnyObject{
    func navigateToHome()
    var view: EditViewController? {get set}
}


class EditRouterImpl: EditRouter{
    
    var view: EditViewController?
    let viewControllerFactory: ViewControllerFactory
    init(viewControllerFactory: ViewControllerFactory) {
        self.viewControllerFactory = viewControllerFactory
    }
    
    func navigateToHome() {
        let next = viewControllerFactory.homeViewController
        //pop(from: view)
        push(next, from: view)
    }
}

extension EditRouterImpl {
    func push<T, E>(_ view: T, from source: E?) {
        guard let source = source as? UIViewController,
              let destination = view as? UIViewController else { return }
        DispatchQueue.main.async {
            source.navigationController?.pushViewController(destination, animated: true)
        }
    }
    func pop<E>(from source: E?) {
        guard let source = source as? UIViewController else {return}
        DispatchQueue.main.async {
            source.navigationController?.popViewController(animated: true)
        }
    }
}
