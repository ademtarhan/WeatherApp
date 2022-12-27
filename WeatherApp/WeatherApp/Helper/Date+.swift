//
//  Date+.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 27.12.2022.
//

import Foundation

extension Date {
    var displayHour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
}
