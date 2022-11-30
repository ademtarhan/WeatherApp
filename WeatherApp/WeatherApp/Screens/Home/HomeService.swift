//
//  HomeService.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 21.10.2022.
//

import Foundation

protocol HomeService: AnyObject {
    func currentWeather(for city: String, _ completionHanlder: @escaping (Result<WeatherResponse, WeatherError>) -> Void)
    func getWeather(_ completionHandler: @escaping (Result<[String: AnyObject]?, WeatherError>) -> Void)
}

// MARK: Calling Api

class HomeServiceImpl: HomeService, APICallable {
    typealias JSON = [String: AnyObject]
    func currentWeather(for city: String, _ completionHanlder: @escaping (Result<WeatherResponse, WeatherError>) -> Void) {
        // TODO: get current weather
    
        let endpoint = "\(BaseURL)weather?q=\(city)&appid=\(APIKey)"

        print("--- \(endpoint)")
        guard let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let endpointURL = URL(string: safeURLString) else {
            completionHanlder(.failure(.invalidURL))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: endpointURL) { data, _, error in
            guard error == nil else {
                completionHanlder(.failure(.requestError))
                return
            }

            guard let responseData = data else {
                completionHanlder(.failure(.timeout))
                return
            }

            do {
                let weatherResponse = try self.decoder.decode(WeatherResponse.self, from: responseData)
                completionHanlder(.success(weatherResponse))
            } catch {
                completionHanlder(.failure(.timeout))
                
            }
        }

        dataTask.resume()
    }

    let session: URLSession

    init(config: URLSessionConfiguration) {
        session = URLSession(configuration: config)
    }

    convenience init() {
        self.init(config: URLSessionConfiguration.default)
    }

    var city = "Malatya"

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    func getWeather(_ completionHandler: @escaping (Result<JSON?, WeatherError>) -> Void) {
        let request = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Malatya&appid=a39be32a3b9802f13a79fcc3ea03e8f5")!
        

        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=524901&appid=a39be32a3b9802f13a79fcc3ea03e8f5")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.requestError))
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON

                        
                        completionHandler(.success(json))
                    } catch {
                        completionHandler(.failure(.JSONParsingError))
                    }
                }
            } else {
                completionHandler(.failure(.timeout))
            }
        })

        task.resume()
    }
}

/*
 https://api.openweathermap.org/data/2.5/weather?q=Malatya&units=metric&appid=a39be32a3b9802f13a79fcc3ea03e8f5 -> for day

  https://api.openweathermap.org/data/2.5/forecast?id=524901&appid=a39be32a3b9802f13a79fcc3ea03e8f5 -> for week

 
 
 
 
 d00811ce34f2ce4e328d693369616d48
 
 https://api.openweathermap.org/data/2.5/forecast/daily?q=London&units=metric&cnt=7&appid=d00811ce34f2ce4e328d693369616d48
 
 https://api.openweathermap.org/data/2.5/forecast/daily?lat=44.34&lon=10.99&cnt=7&appid=a39be32a3b9802f13a79fcc3ea03e8f5
 
 https://samples.openweathermap.org/data/2.5/forecast?id=524901&appid=a39be32a3b9802f13a79fcc3ea03e8f5
 
 
 https://api.openweathermap.org/data/2.5/weather?q=Malatya&appid=a39be32a3b9802f13a79fcc3ea03e8f5
 
 */
