//
//  HomeAssembly.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 19.10.2022.
//

import Foundation

import Swinject

class HomeAssembly: Assembly{
    func assemble(container: Container) {
        container.register(HomeViewController.self) { r in
            let viewController = HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
            return viewController
        }
    }
}
