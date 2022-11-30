//
//  EventInteractor.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 27.11.2022.
//

import Foundation


protocol EventInteractor: AnyObject{
    var service: EventService? {get set}
    func saveEvent(data: EventModel, completionHandler: @escaping (Result<Any,FirebaseError>) -> Void)
}

class EventInteractorImpl: EventInteractor{
    var service: EventService?
    
    func saveEvent(data: EventModel, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        let eventModel = EventModel(date: data.date, title: data.title, description: data.description, eventID: service?.eventID ?? "")
        print(eventModel)
        service?.saveEvent(data: eventModel, completionHandler: { result in
            switch result{
            case let .success(event):
                //..MARK:
                completionHandler(.success(event))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        })
    }
    
}
