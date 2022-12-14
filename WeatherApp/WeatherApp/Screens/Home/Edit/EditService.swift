//
//  EditService.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 14.12.2022.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


protocol EditService: AnyObject{
    func updateEvent(with event: EventModel) async throws -> Bool
    func updateData(with event: EventModel, completionHandler: @escaping (Result<EventModel,FirebaseError>) -> Void)
}

class EditServiceImpl: EditService{
    let currentUserID = Auth.auth().currentUser?.uid
    let firebaseREF = Database.database().reference().ref
    
    func updateData(with event: EventModel, completionHandler: @escaping (Result<EventModel, FirebaseError>) -> Void) {
        dlog(self, "willSetData")
        dlog(self, "\(event)")
        firebaseREF.child("events").child("\(event.eventID)").setValue(["date":event.date,"description":event.description,"title":event.title,"eventID":event.eventID]) { error, _ in
            if let _ = error {
                dlog(self, "didNotSetData")
                completionHandler(.failure(.setDataError))
            }else{
                dlog(self, "didSetData")
                completionHandler(.success(event))
            }
        }
    }
    
    
    func updateEvent(with event: EventModel) async throws -> Bool {
        try await withCheckedThrowingContinuation({ contination in
            firebaseREF.child("events").child("\(event.eventID)").setValue(true) {
                contination.resume(returning: true)
            }
        })
    }
}
