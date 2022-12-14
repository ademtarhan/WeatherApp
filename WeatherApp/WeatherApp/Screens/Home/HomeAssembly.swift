//
//  HomeAssembly.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 19.10.2022.
//

import Foundation

import Swinject

class HomeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewController.self) { r in
            let viewController = HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
            let presenter = r.resolve(HomePresenter.self)!
            let interactor = r.resolve(HomeInteractor.self)!
            let service = r.resolve(HomeService.self)!
            let router = r.resolve(HomeRouter.self)!
            let editView = r.resolve(EditViewController.self)!

            viewController.presenter = presenter
            viewController.router = router
            viewController.editView = editView
            presenter.interactor = interactor
            presenter.router = router
            interactor.service = service
            presenter.view = viewController
            router.view = viewController

            return viewController
        }
        
        container.register(EditViewController.self) { _ in
            EditViewControllerImpl()
        }

        container.register(HomePresenter.self) { _ in
            HomePresenterImpl()
        }
        container.register(HomeInteractor.self) { _ in
            HomeInteractorImpl()
        }
        container.register(HomeService.self) { _ in
            HomeServiceImpl()
        }
        container.register(HomeRouter.self) { r in
            HomeRouterImpl(viewControllerFactory: r.resolve(ViewControllerFactory.self)!)
        }
    }
}
