//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 16.11.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var minC: UILabel!
    @IBOutlet var maxC: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayLabel.textColor = UIColor(named: "foreGround")
        minC.textColor = UIColor(named: "foreGround")
        maxC.textColor = UIColor(named: "foreGround")
        weatherIconImage.tintColor = UIColor(named: "foreGround")
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(weather: DailyWeatherModel) {
        dayLabel.text = weather.name
        minC.text = String(weather.sunrise)
        maxC.text = String(weather.humidity)
        weatherIconImage.image = UIImage(systemName: weather.iconName)
    }
}
