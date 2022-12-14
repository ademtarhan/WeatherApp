//
//  EditPresenter.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 14.12.2022.
//

import Foundation


protocol EditPresenter: AnyObject{
    var interactor: EditInteractor? {get set}
    var router: EditRouter? {get set}
    
    func updateEvent(date: String, title: String, description: String,eventID: String)
    
}

class  EditPresenterImpl: EditPresenter{
    var interactor: EditInteractor?
    var router: EditRouter?
    
    
    
    
    func updateEvent(date: String, title: String, description: String,eventID: String){
        let event = EventModel(date: date, title: title, description: description, eventID: eventID)
        
        interactor?.updateData(with: event, completionHandler: { result in
            switch result{
            case .success:
                self.router?.navigateToHome()
            case .failure:
                //TODO: fail message
                break
            }
        })
        /*
        Task{
            try await interactor?.updateEvent(with: event)
        }
        */
    }
    
    
    
    
}
