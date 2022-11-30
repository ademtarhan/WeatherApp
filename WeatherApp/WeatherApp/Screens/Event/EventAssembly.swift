//
//  EventAssembly.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 27.11.2022.
//

import Foundation
import Swinject

class EventAssembly: Assembly{
    func assemble(container: Container) {
        container.register(EventViewController.self) { r in
            let view = EventViewControllerImpl(nibName: "EventViewController", bundle: nil)
            let service = r.resolve(EventService.self)!
            let presenter = r.resolve(EventPresenter.self)!
            let interactor = r.resolve(EventInteractor.self)!
            let router = r.resolve(EventRouter.self)!
            view.presenter = presenter
            interactor.service = service
            presenter.interactor = interactor
            presenter.view = view
            router.view = view
            presenter.router = router
            
            
            return view
        }
        container.register(EventService.self){ _ in
            EventServiceImpl()
        }
        container.register(EventPresenter.self){ _ in
            EventPresenterImpl()
        }
        container.register(EventInteractor.self){ _ in
            EventInteractorImpl()
        }
        container.register(EventRouter.self) { r in
            EventRouterImpl(viewControllerFactory: r.resolve(ViewControllerFactory.self)!)
        }
    }
}
