//
//  EventTableViewCell.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 1.12.2022.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    
    @IBOutlet  var dateLabel: UILabel!
    @IBOutlet  var titleLabel: UILabel!
    @IBOutlet  var decriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(eventModel: EventModel){
        dateLabel.text = eventModel.date
        titleLabel.text = eventModel.title
        decriptionLabel.text = eventModel.description
    }
    
}
