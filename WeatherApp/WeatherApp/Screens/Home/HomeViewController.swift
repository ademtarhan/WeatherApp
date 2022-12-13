//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 13.10.2022.
//

import UIKit
import UserNotifications

protocol HomeViewController: AnyObject {
    var presenter: HomePresenter? { get set }
    var router: HomeRouter? { get set }
    func display(_ current: WeatherEntity.Current.ViewModel)
    func setData(with events: [EventModel])
}

class HomeViewControllerImpl: UIViewController, HomeViewController {
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var minMaxView: UIView!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var maxTemperatureLabel: UILabel!
    @IBOutlet var minTemperatureLabel: UILabel!

    var presenter: HomePresenter?
    var router: HomeRouter?
    var weatherWeekly = [DailyWeatherModel]()
    var eventData = [EventModel]()
    let center = UNUserNotificationCenter.current()
    var notificationBody: String = ""

    @IBOutlet var blueView: UIView!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        blueView.layer.opacity = 0.8

        weatherWeekly.append(DailyWeatherModel(name: "Today", sunrise: "6º", sunset: 12, humidity: "13º", temp: 12, wind: 12, iconName: "cloud.sun.fill"))
        weatherWeekly.append(DailyWeatherModel(name: "Friday", sunrise: "5º", sunset: 12, humidity: "13º", temp: 12, wind: 12, iconName: "cloud.fill"))
        weatherWeekly.append(DailyWeatherModel(name: "Saturday", sunrise: "7º", sunset: 12, humidity: "15º", temp: 12, wind: 12, iconName: "cloud.sun.fill"))
        weatherWeekly.append(DailyWeatherModel(name: "Sunday", sunrise: "6º", sunset: 12, humidity: "15º", temp: 12, wind: 12, iconName: "sun.min.fill"))
        weatherWeekly.append(DailyWeatherModel(name: "Monday", sunrise: "7º", sunset: 12, humidity: "14º", temp: 12, wind: 12, iconName: "cloud.fill"))
        weatherWeekly.append(DailyWeatherModel(name: "Tuesday", sunrise: "6º", sunset: 12, humidity: "14º", temp: 12, wind: 12, iconName: "cloud.fill"))
        weatherWeekly.append(DailyWeatherModel(name: "Wednesday", sunrise: "6º", sunset: 12, humidity: "14º", temp: 12, wind: 12, iconName: "cloud.sun.fill"))
/*
        eventData.append(EventModel(date: "01.12.2022", title: "event1", description: "description1", eventID: "1"))
        eventData.append(EventModel(date: "01.12.2022", title: "event2", description: "description1", eventID: "1"))
        eventData.append(EventModel(date: "01.12.2022", title: "event3", description: "description1", eventID: "1"))
        eventData.append(EventModel(date: "01.12.2022", title: "event4", description: "description1", eventID: "1"))
        eventData.append(EventModel(date: "01.12.2022", title: "event5", description: "description1", eventID: "1"))
        eventData.append(EventModel(date: "01.12.2022", title: "event6", description: "description1", eventID: "1"))
        eventData.append(EventModel(date: "01.12.2022", title: "event7r", description: "description1", eventID: "1"))
*/
        presenter?.getData()
        view.backgroundColor = UIColor(named: "background")
        presenter?.getWeather()
        presenter?.getCurrentWeather()
        tableView.delegate = self
        tableView.dataSource = self
        let nibCell = UINib(nibName: "EventTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "eventCell")
        // setUpView()
        // setupLayout()
        // setLocalNotifactions()
        // gifView.loadGif(name: "weather3")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setLocalNotifactions() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
        }

        let content = UNMutableNotificationContent()
        content.title = "Weather For Tomorrow"
        content.body = notificationBody

        var date = DateComponents()
        date.hour = 22
        date.minute = 01

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        center.add(request) { _ in

            // MARK: error
        }
    }

    @IBAction func didTapAddEvent(_ sender: Any) {
        router?.navigateToEvent()
    }
    
    func setData(with events: [EventModel]) {
        eventData = events
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeViewControllerImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableViewCell

        // cell.layer.borderColor = UIColor(named: "blueTone")?.cgColor
        // cell.layer.borderWidth = 1
        // cell.layer.cornerRadius = 20
        // cell.setData(weather: weatherWeekly[indexPath.row])

        cell.setData(eventModel: eventData[indexPath.row])
        return cell
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { rowAction, indexPath in
            dlog(self, "did tap delete")
            let event = self.eventData.remove(at: indexPath.row)
            self.presenter?.deleteEvent(with: event)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        deleteButton.backgroundColor = UIColor(named: "gradient")
        
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { rowAction, indexPath in
            print("tap edit")
            self.router?.navigateToEvent()
        }
        editButton.backgroundColor = UIColor(named: "blueTone")
        
        return [deleteButton,editButton]
    }
}

extension HomeViewControllerImpl {
    func display(_ current: WeatherEntity.Current.ViewModel) {
        DispatchQueue.main.async {
            self.locationLabel.text = current.location
            self.temperatureLabel.text = current.temperature
            self.windLabel.text = current.wind
            self.feelsLikeLabel.text = current.feelsLike
            self.humidityLabel.text = current.humidity
            self.minTemperatureLabel.text = current.minTemperature
            self.maxTemperatureLabel.text = current.maxTemperature
            self.notificationBody = "Min Temp:\(current.minTemperature)\nMax Temp:\(current.maxTemperature)\nFeels Like:\(current.feelsLike)"
            self.iconImage.image = current.icon
        }
    }
}
