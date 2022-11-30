//
//  ViewControllerFactory.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 13.10.2022.
//

import Foundation
import Swinject

protocol ViewControllerFactory: AnyObject {
    var homeViewController: HomeViewController { get }
    var eventViewController: EventViewController {get}
}

class ViewControllerFactoryImpl: ViewControllerFactory {
    private let assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
    }

    var homeViewController: HomeViewController {
        assembler.resolver.resolve(HomeViewController.self)!
    }
    var eventViewController: EventViewController{
        assembler.resolver.resolve(EventViewController.self)!
    }
}
