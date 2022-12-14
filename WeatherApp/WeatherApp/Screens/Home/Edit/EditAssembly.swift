//
//  EditAssembly.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 14.12.2022.
//

import Foundation
import Swinject

class EditAssembly: Assembly{
    func assemble(container: Container) {
        container.register(EditViewController.self) { r in
            let view = EditViewControllerImpl(nibName: "EditViewController", bundle: nil)
            let presenter = r.resolve(EditPresenter.self)!
            let interactor = r.resolve(EditInteractor.self)!
            let router = r.resolve(EditRouter.self)!
            let service = r.resolve(EditService.self)!
            
            
            view.presenter = presenter
            presenter.interactor = interactor
            presenter.router = router
            interactor.service = service
            router.view = view
            
            return view
        }
        
        
        container.register(EditPresenter.self) { _ in
            EditPresenterImpl()
        }
        container.register(EditInteractor.self) { _ in
            EditInteractorImpl()
        }
        container.register(EditService.self) { _ in
            EditServiceImpl()
        }
        container.register(EditRouter.self) { r in
            EditRouterImpl(viewControllerFactory: r.resolve(ViewControllerFactory.self)!)
        }
    }
}
