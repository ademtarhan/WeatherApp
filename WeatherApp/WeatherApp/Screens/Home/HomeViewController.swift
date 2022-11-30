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
    var router: HomeRouter? {get set}
    func display(_ current: WeatherEntity.Current.ViewModel)
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
    let center = UNUserNotificationCenter.current()
    var notificationBody: String = ""

    @IBOutlet var blueView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
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

        view.backgroundColor = UIColor(named: "background")
        presenter?.getWeather()
        presenter?.getCurrentWeather()
        tableView.delegate = self
        tableView.dataSource = self
        let nibCell = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "cell")
        // setUpView()
        // setupLayout()
        setLocalNotifactions()
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
}

extension HomeViewControllerImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherWeekly.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell

        // cell.layer.borderColor = UIColor(named: "blueTone")?.cgColor
        // cell.layer.borderWidth = 1
        // cell.layer.cornerRadius = 20
        cell.setData(weather: weatherWeekly[indexPath.row])
        return cell
    }

    /*
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == UITableViewCell.EditingStyle.delete {

             tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
         }
     }
      */
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
