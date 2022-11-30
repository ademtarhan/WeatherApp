//
//  AuthAssembly.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 2.11.2022.
//

import Foundation
import Swinject

class AuthAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthViewController.self) { r in
            let view = AuthViewControllerImpl(nibName: "AuthViewController", bundle: nil)
            let presenter = r.resolve(AuthPresenter.self)!
            let interactor = r.resolve(AuthInteractor.self)!
            let router = r.resolve(AuthRouter.self)!
            let service = r.resolve(AuthService.self)!

            view.presenter = presenter
            presenter.router = router
            presenter.interactor = interactor
            interactor.service = service
            router.view = view

            return view
        }
        container.register(AuthRouter.self) { r in
            AuthRouterImpl(viewControllerFactory: r.resolve(ViewControllerFactory.self)!)
        }
        container.register(AuthPresenter.self) { _ in
            AuthPresenterImpl()
        }
        container.register(AuthInteractor.self) { _ in
            AuthInteractorImpl()
        }
        container.register(AuthService.self) { _ in
            AuthServiceImpl()
        }
    }
}
