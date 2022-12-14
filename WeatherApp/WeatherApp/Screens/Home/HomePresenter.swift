//
//  HomePresenter.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 13.10.2022.
//

import Foundation
import UIKit

protocol HomePresenter: AnyObject {
    var interactor: HomeInteractor? { get set }
    var view: HomeViewController? { get set }
    var router: HomeRouter? {get set}
    func getCurrentWeather()
    func getWeather()
    func deleteEvent(with event: EventModel)
    func getData()
    func logOut()
}

class HomePresenterImpl: HomePresenter {
    var interactor: HomeInteractor?
    var view: HomeViewController?
    var city = "Malatya"
    var eventArray = [EventModel]()
    var currentDay: Date?
    var router: HomeRouter?

    init() {
        currentDay = Date()
    }

    func getCurrentWeather() {
        // TODO:
        interactor?.currentWeather(for: city, { result in
            switch result {
            case let .success(data):
                self.updateCurrent(data)
            case let .failure(error):
                dlog(self, "\(error)")
            }
        })
    }

    func getWeather() {
        interactor?.getWeather({ result in
            switch result {
            case .failure:
                // TODO: Error message
                break
            case let .success(data):
                self.view?.hourlyWeatherDisplay(self.setHourlyWeather(with: data))
            }
        })
    }

    private func updateCurrent(_ weather: WeatherResponse) {
        
        var icon: UIImage = UIImage(systemName: "sun.min.fill")!
        if let desctiptionIcon = weather.weather?.first?.weatherDescription {
            
            if "\(desctiptionIcon)" == "overcast clouds" {
                icon = UIImage(systemName: "cloud.fill")!
            } else if "\(desctiptionIcon)" == "broken clouds" {
                icon = UIImage(systemName: "cloud.sun.fill")!
            } else if "\(desctiptionIcon)" == "scattered clouds" {
                icon = UIImage(systemName: "cloud.fill")!
            } else if "\(desctiptionIcon)" == "rain" {
                icon = UIImage(systemName: "rain.fill")!
            } else if "\(desctiptionIcon)" == "fog" {
                icon = UIImage(systemName: "cloud.fog.fill")!
            } else if "\(desctiptionIcon)" == "lightning" {
                icon = UIImage(systemName: "cloud.bolt.rain.fill")!
            } else {
                icon = UIImage(systemName: "sun.min")!
            }
        }

        let location = weather.name ?? "Cannot find city"

        var temperatureString = ""
        if let temperature = weather.main?.temp {
            temperatureString = "\(Int(temperature - 273))??"
        }

        var feelsLikeString = "No feels like"
        if let feelsLike = weather.main?.feelsLike {
            feelsLikeString = "\(Int(feelsLike - 273))??"
        }

        var highTempString = "No high temp"
        if let high = weather.main?.tempMax {
            highTempString = "\(Int(high - 273))??"
        }

        var lowTempString = "No high temp"
        if let low = weather.main?.tempMin {
            lowTempString = "\(Int(low - 273))??"
        }

        var windString = "No wind"
        if let wind = weather.wind?.speed {
            windString = "\(Int(wind))km/h"
        }

        var humidityString = "No humidity"
        if let humidity = weather.main?.humidity {
            humidityString = "%\(humidity)"
        }

        let weatherModel = WeatherEntity.Current.ViewModel(location: location, temperature: temperatureString, feelsLike: feelsLikeString, minTemperature: lowTempString, maxTemperature: highTempString, wind: windString, humidity: humidityString, icon: icon)

        view?.display(weatherModel)
    }

    func setHourlyWeather(with weatherList: HourWeatherResponse) -> [HourlyWeatherModel] {
        var hourlyWeatherArray = [HourlyWeatherModel]()
        var icon = UIImage(systemName: "sun.min.fill")!
        var lowTempature = "No low high"
        var hourText = "No date"

        weatherList.list?.forEach({ list in
            if let lowTemp = list.main?.tempMin {
                lowTempature = "\(Int(lowTemp - 273))??"
            }

            hourText = "\(list.dtTxt.displayHour)"
            
            list.weather?.forEach({ weather in
                if let desctiptionIcon = weather.weatherDescription {
                    if "\(desctiptionIcon)" == "overcast clouds" {
                        icon = UIImage(systemName: "cloud.fill")!
                    } else if "\(desctiptionIcon)" == "broken clouds" {
                        icon = UIImage(systemName: "cloud.sun.fill")!
                    } else if "\(desctiptionIcon)" == "scattered clouds" {
                        icon = UIImage(systemName: "cloud.fill")!
                    } else if "\(desctiptionIcon)" == "rain" {
                        icon = UIImage(systemName: "rain.fill")!
                    } else if "\(desctiptionIcon)" == "fog" {
                        icon = UIImage(systemName: "cloud.fog.fill")!
                    } else if "\(desctiptionIcon)" == "lightning" {
                        icon = UIImage(systemName: "cloud.bolt.rain.fill")!
                    }else if "\(desctiptionIcon)" == "clear sky" {
                        icon = UIImage(systemName: "cloud.bolt.rain.fill")!
                    } else {
                        icon = UIImage(systemName: "sun.min")!
                    }
                }

                let hourWeather = HourlyWeatherModel(hourText: hourText, iconDescription: icon, lowTempature: lowTempature)
                hourlyWeatherArray.append(hourWeather)
            })
        })

        return hourlyWeatherArray
    }

    func deleteEvent(with event: EventModel) {
        interactor?.deleteEvent(with: event, completionHandler: { result in
            guard let _ = try? result.get() else {
                dlog(self, "didNotSuccessDeleteProcess")
                // TODO: show error message
                return
            }
            dlog(self, "didSuccessDeleteProcess")
        })
    }

    func getData() {
        interactor?.getData(completionHandler: { result in
            guard let eventsData = try? result.get() else {
                // TODO: show fetch error
                return
            }
            self.eventArray = eventsData as! [EventModel]
            let sortedArray = self.eventArray.sorted { $0.date < $1.date }
            self.view?.setData(with: sortedArray)

        })
    }
    
    func logOut(){
        interactor?.logOut(completionHandler: { result in
            guard let _ = try? result.get() else {
                dlog(self, "already logged out")
                return
            }
            self.router?.navigateToAuth()
        })
    }
}
