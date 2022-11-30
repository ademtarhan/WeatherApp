//
//  APICallable.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 21.10.2022.
//

import Foundation

protocol APICallable: AnyObject {
    var BaseURL: String { get }
    var APIKey: String { get }
}

extension APICallable {
    var APIKey: String { return "a39be32a3b9802f13a79fcc3ea03e8f5" }
    var BaseURL: String { return "https://api.openweathermap.org/data/2.5/" }
}

/*
 https://api.openweathermap.org/data/2.5/
 
 forecast?id=524901&appid=
 
 a39be32a3b9802f13a79fcc3ea03e8f5 
 
 */
