//
//  EventPresenter.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 27.11.2022.
//

import Foundation

protocol EventPresenter: AnyObject {
    var view: EventViewController? {get set}
    var router: EventRouter? {get set}
    var interactor: EventInteractor? { get set }
    func saveEvent(date: String, title: String, description: String)
}

class EventPresenterImpl: EventPresenter {
    var router: EventRouter?
    var view: EventViewController?
    var interactor: EventInteractor?
    func saveEvent(date: String, title: String, description: String) {
        let dataModel = EventModel(date: date, title: title, description: description,eventID: "")
        // ..MARK:
        print(dataModel)
        interactor?.saveEvent(data: dataModel, completionHandler: { result in
            switch result{
            case .success:
                print("save data")
                //..TODO: navigate to home screen
                self.router?.navigateToHome()
            case let .failure(error):
                print(error)
            }
        })
    }
}
