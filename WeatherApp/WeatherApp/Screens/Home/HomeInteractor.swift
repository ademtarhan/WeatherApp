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
    func getWeather(_ completionHandler: @escaping (Result<[String: AnyObject]?, WeatherError>) -> Void)
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

    func getWeather(_ completionHandler: @escaping (Result<JSON?, WeatherError>) -> Void) {
        service?.getWeather({ result in
            switch result {
            case let .success(data):
                completionHandler(.success(data))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        })
    }
}
