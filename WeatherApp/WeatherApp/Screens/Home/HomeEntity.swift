//
//  HomeEntity.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 13.10.2022.
//

import Foundation
import UIKit

enum WeatherError: Error {
    case invalidURL
    case timeout
    case requestError
    case JSONParsingError
}

struct DailyWeatherModel: Codable {
    var name: String
    var sunrise: String
    var sunset: Int
    var humidity: String
    var temp: Int
    var wind: Int
    var iconName: String
}

struct WeatherEntity {
    struct Current {
        struct ViewModel {
           let location: String
        //    let condition: String
            let temperature: String
            let feelsLike: String
            let minTemperature: String
            let maxTemperature: String
            let wind: String
            let humidity: String
            let icon: UIImage
        }
    }

    struct Daily {
        struct ViewModel {
            let day: String
            let condition: String
            let temperature: String
        }
    }
}


struct CurrentWeather{
    let temperature: Double
    let rainfall : String
    let humidity : Double
    let icon : String
    let location : String
    init(temperature: Double, rainfall: String, humidity: Double,icon: String,location: String){
        self.temperature = temperature
        self.rainfall = rainfall
        self.humidity = humidity
        self.icon = icon
        self.location = location
    }
}



extension CurrentWeather {
    var iconWeather: UIImage {
        switch icon {
        case "clear-day" : return UIImage(named: "sun")!
        case "clear-night" : return UIImage(named: "clear-night")!
        case "rain" : return UIImage(named: "rain")!
        case "snow" : return UIImage(named: "snow")!
        case "wind" : return UIImage(named: "wind")!
        case "fog" : return UIImage(named: "fog")!
        case "cloudy" : return UIImage(named: "cloudy")!
        default:
            return UIImage(named: "cloud.fill") ?? UIImage(named: "cloud.fill") as! UIImage
        }
    }
}

extension CurrentWeather {
    struct Key {
        static let temperature = "temperature"
        static let rainFall = "rainFall"
        static let humidity = "humidity"
        static let icon = "icon"
    }
    
    init?(json : [String:AnyObject]){
        guard let temperature = json[Key.temperature] as? Double,
              let rainFall = json[Key.rainFall] as? String,
              let humdity = json[Key.humidity] as? Double,
              let icon = json[Key.icon] as? String else {
                  return nil
              }
        self.temperature = temperature
        self.rainfall = rainFall
        self.humidity = humdity
        self.icon = icon
        return nil
    }
    
   
    
}


// MARK: - Welcome
struct WeatherResponse: Codable {
    let coord: Coord?
    let weather: [Weather]?
    //let base: String
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    //let dt: Int
   // let sys: Sys
    //let timezone, id: Int
    let name: String?
    let cod: Int?
}




// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon: Int?
    let lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}




//MARK: Daily Response


struct DailyResponse: Codable {
    let daily: [Daily]?
}

// MARK: - Daily
struct Daily: Codable {
    let date, sunrise, sunset, moonrise: Int?
    let moonset: Int?
    let moonPhase: Double?
    let temp: Temp?
    let feelsLike: FeelsLike?
    let pressure, humidity: Int?
    let dewPoint, windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [Weather]?
    let clouds: Int?
    let pop, uvi, rain: Double?

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double?
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double?
    let eve, morn: Double?
}


/*


// MARK: Hourly

struct HourWeatherResponse: Codable {
    let list: [HourlyList]
}

// MARK: - List
struct HourlyList: Codable {
    let main: MainClass
    let weather: [HourlyWeather]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dtTxt = "date_text"
    }
}


// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}


// MARK: - Weather
struct HourlyWeather: Codable {
    let weatherDescription: Description
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

*/


// MARK: - HourWeatherResponse
struct HourWeatherResponse: Codable {
    let list: [HourlyList]?
}

// MARK: - List
struct HourlyList: Codable {
    let main: MainClass?
    let weather: [HourlyWeather]?
    let dtTxt: Date

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case tempKf = "temp_kf"
    }
}


// MARK: - Weather
struct HourlyWeather: Codable {
    let id: Int
    let weatherDescription: String?
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case weatherDescription = "description"
        case icon
    }
}

/*
enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightSnow = "light snow"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}
*/




struct HourlyWeatherModel{
    let hourText: String
    let iconDescription: UIImage
    let lowTempature: String
}
