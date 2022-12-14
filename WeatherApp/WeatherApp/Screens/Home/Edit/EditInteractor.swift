//
//  EditInteractor.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 14.12.2022.
//

import Foundation


protocol EditInteractor: AnyObject{
    var service: EditService? {get set}
    func updateEvent(with event: EventModel) async throws -> Bool
    func updateData(with event: EventModel, completionHandler: @escaping (Result<EventModel,FirebaseError>) -> Void)
}

class  EditInteractorImpl: EditInteractor{
    var service: EditService?
    
    
    func updateData(with event: EventModel, completionHandler: @escaping (Result<EventModel, FirebaseError>) -> Void) {
        service?.updateData(with: event, completionHandler: { result in
            switch result{
            case let .success(event):
                dlog(self, "didSetData")
                completionHandler(.success(event))
            case .failure:
                dlog(self, "didNotSetData")
                completionHandler(.failure(.setDataError))
            }
        })
    }
    
    func updateEvent(with event: EventModel) async throws -> Bool {
        //TODO:
        try await service?.updateEvent(with: event)
        return true
    }
}
