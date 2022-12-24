//
//  HomeService.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 21.10.2022.
//

import FirebaseAuth
import FirebaseDatabase
import Foundation

protocol HomeService: AnyObject {
    func currentWeather(for city: String, _ completionHanlder: @escaping (Result<WeatherResponse, WeatherError>) -> Void)
    func getWeather(_ completionHandler: @escaping (Result<[String: AnyObject]?, WeatherError>) -> Void)
    func deleteEvent(with event: EventModel, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void)
    func getData(completionHandler: @escaping (Result<[EventModel], FirebaseError>) -> Void)
    func fetchEventsFromUsers(completionHandler: @escaping (Result<[String], FirebaseError>) -> Void)
    func fetchEventsFromEvents(with eventID: String, completionHandler: @escaping (Result<[EventModel], FirebaseError>) -> Void)
}

// MARK: Calling Api

class HomeServiceImpl: HomeService, APICallable {
    var eventArray = [EventModel]()
    let firebaseREF = Database.database().reference()

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

    func deleteEvent(with event: EventModel, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        let currenUserID = Auth.auth().currentUser?.uid
        dlog(self, "\(currenUserID)")
        dlog(self, "willDelete")
        firebaseREF.child("events").child(event.eventID).removeValue { error, _ in
            if error != nil {
                dlog(self, "didNotDeleteError -> \(error)")
                completionHandler(.failure(.deleteError))
                return
            } else {
                dlog(self, "didDeletedEvent")
                self.firebaseREF.child("users").child("\(currenUserID!)").child("events").child("\(event.eventID)").removeValue { error, _ in
                    if error != nil {
                        dlog(self, "didNotDeleteEventInUsers -> \(error)")
                        completionHandler(.failure(.deleteError))
                        return
                    } else {
                        dlog(self, "didDeletedEventInUsers")
                        completionHandler(.success(true))
                    }
                }
            }
        }
    }

    func getData(completionHandler: @escaping (Result<[EventModel], FirebaseError>) -> Void) {
        dlog(self, "willGetData")
        var group = DispatchGroup()
        var eventS = [EventModel]()
        fetchEventsFromUsers { result in
            guard let events = try? result.get() else {
                dlog(self, "didNotFetchEventFromUsers")
                completionHandler(.failure(.fetchEventsError))
                return
            }
            events.forEach { event in
                group.enter()
                self.fetchEventsFromEvents(with: event) { result in
                    guard let eventData = try? result.get() else {
                        completionHandler(.failure(.fetchEventsError))
                        return
ı                    }
                    eventS = eventData
                    group.leave()
                }
            }
            group.notify(queue: .global(qos: .background)) {
                dlog(self, "\(eventS.count)")
                completionHandler(.success(eventS))
            }
        }
    }

    func fetchEventsFromUsers(completionHandler: @escaping (Result<[String], FirebaseError>) -> Void) {
        dlog(self, "willFetchEventsInUser")
        let userID = Auth.auth().currentUser?.uid
        firebaseREF.child("users").child("\(userID!)").child("events").getData { error, snapShot in
            if let _ = error {
                dlog(self, "didNotFetchEventFromUsers")
                completionHandler(.failure(.fetchEventsError))
            } else {
                guard let value = snapShot?.value as? [String: Any] else { return }
                // guard let events = value["events"] as? [String:Any] else {return}
                let eventIDs = Array(value.keys)
                dlog(self, "didFetchEventsInUsers")
                completionHandler(.success(eventIDs))
            }
        }
    }

    func fetchEventsFromEvents(with eventID: String, completionHandler: @escaping (Result<[EventModel], FirebaseError>) -> Void) {
        dlog(self, "willFetchEventsInEvents")

        firebaseREF.child("events").child("\(eventID)").ref.getData { error, snapShot in
            if let _ = error {
                dlog(self, "didNotFetchEvents -> \(error)")
                completionHandler(.failure(.fetchEventsError))
                return
            } else {
                if snapShot!.exists() {
                    guard let event = snapShot?.value as? [String: Any] else { return }
                    guard let title = event["title"] as? String,
                          let description = event["description"] as? String,
                          let date = event["date"] as? String,
                          let eventID = event["eventID"] as? String
                    else {
                        dlog(self, "didNotConvertData")
                        return
                    }
                    let eventItem = EventModel(date: date, title: title, description: description, eventID: eventID)
                    self.eventArray.append(eventItem)
                    completionHandler(.success(self.eventArray))
                } else {
                    dlog(self, "snapshotIsNull")
                    completionHandler(.failure(.fetchEventsError))
                }
            }
        }
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
