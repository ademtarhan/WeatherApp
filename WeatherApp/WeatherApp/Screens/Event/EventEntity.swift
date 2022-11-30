//
//  EventEntity.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 27.11.2022.
//

import Foundation

struct EventModel {
    let date: String
    let title: String
    let description: String
    let eventID: String

    enum CodinKeys: String {
        case date
        case title
        case description
        case eventID
    }

    var asJson: [String: Any] {
        return ["date": date, "title": title, "description": description, "eventID": eventID]
    }
}

enum FirebaseError: Error {
    case timeOut
    case wrongPassword
    case invalidEmail
    case unKnownError
    case documentsError
    case fetchBooksError
    case saveDataError
    case deleteError
}
