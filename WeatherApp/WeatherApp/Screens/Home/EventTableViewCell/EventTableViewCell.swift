//
//  EventTableViewCell.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 1.12.2022.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet var decriptionLabel: UILabel!

    var currentDate: Date!

    override func awakeFromNib() {
        super.awakeFromNib()
        currentDate = Date()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(eventModel: EventModel) {
        if currentDate.asDisplayDate < eventModel.date {
            dateView.backgroundColor = UIColor(named: "purple")
        }else if currentDate.asDisplayDate == eventModel.date {
            dateView.backgroundColor = UIColor(named: "blueTone")
        }else {
            dateView.backgroundColor = UIColor(named: "gradient")
        }
        
        dateLabel.text = eventModel.date
        titleLabel.text = eventModel.title
        decriptionLabel.text = eventModel.description
    }
}

extension Date {
    var asDate: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }

    var asDisplayDate: String! {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter.string(from: self)
    }

    var currentDay: Date {
        return Date()
    }

    var previousDay: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}
