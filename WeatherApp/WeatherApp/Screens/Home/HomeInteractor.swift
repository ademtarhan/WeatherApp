//
//  HomeInteractor.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 13.10.2022.
//

import Foundation

protocol HomeInteractor: AnyObject {
    var service: HomeService? { get set }
    func currentWeather(for city: String, _ completionHanlder: @escaping (Result<WeatherResponse, WeatherError>) -> Void)
    func getWeather(_ completionHandler: @escaping (Result<HourWeatherResponse, WeatherError>) -> Void)
    func deleteEvent(with event: EventModel,completionHandler: @escaping (Result<Any,FirebaseError>) -> Void)
    func getData(completionHandler: @escaping (Result<Any,FirebaseError>) -> Void)
    func logOut(completionHandler: @escaping (Result<Any, FirebaseError>) -> Void)
}

class HomeInteractorImpl: HomeInteractor {
    typealias JSON = [String: AnyObject]
    var service: HomeService?

    func currentWeather(for city: String, _ completionHanlder: @escaping (Result<WeatherResponse, WeatherError>) -> Void) {
        service?.currentWeather(for: city, { result in
            switch result {
            case let .success(data):
                completionHanlder(.success(data))
            case let .failure(error):
                completionHanlder(.failure(error))
            }
        })
    }

    func getWeather(_ completionHandler: @escaping (Result<HourWeatherResponse, WeatherError>) -> Void) {
        service?.getHourWeather({ result in
            switch result {
            case let .success(data):
                completionHandler(.success(data))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        })
    }
    
    func deleteEvent(with event: EventModel, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        service?.deleteEvent(with: event, completionHandler: { result in
            guard let _ = try? result.get() else {
                dlog(self, "didNotSuccessDeleteProcess")
                completionHandler(.failure(.deleteError))
                return
            }
            dlog(self, "didSuccessDeleteProcess")
            completionHandler(.success(true))
        })
    }
    
    func getData(completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        service?.getData(completionHandler: { result in
            guard let data = try? result.get() else {
                completionHandler(.failure(.fetchEventsError))
                return
            }
            completionHandler(.success(data))
        })
    }
    
    func logOut(completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        service?.logOut(completionHandler: { result in
            guard let _ = try? result.get() else {
                completionHandler(.failure(.logoutError))
                return
            }
            completionHandler(.success(true))
        })
    }
}
