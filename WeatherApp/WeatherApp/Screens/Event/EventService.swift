//
//  EventService.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 27.11.2022.
//

import FirebaseDatabase
import Foundation
import FirebaseAuth

protocol EventService: AnyObject {
    var eventID: String! { get }
    func saveEvent(data: EventModel, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void)
}

class EventServiceImpl: EventService {
    var currentUserID = Auth.auth().currentUser?.uid
    
    var eventID: String! {
        firebaseRef.childByAutoId().key ?? ""
    }

    let firebaseRef = Database.database().reference()

    func saveEvent(data: EventModel, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        let userID = "iEEiCMmuGeZ45PdMoFJqsewWSM42"

        let userReference = firebaseRef.child("users").child(currentUserID!).child("events").child("\(data.eventID)").ref

        userReference.setValue(true) { [self] error, reference in
            guard let bookKey = reference.key else { return }
            let eventReference = firebaseRef.child("events").child("\(data.eventID)").ref
            if let _ = error {
                completionHandler(.failure(.saveDataError))
            } else {
                eventReference.setValue(data.asJson) { error, _ in
                    if let _ = error {
                        completionHandler(.failure(.saveDataError))
                    } else {
                        completionHandler(.success(true))
                    }
                }
            }
        }
    }
}
