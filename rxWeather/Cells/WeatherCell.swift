//
//  WeatherCell.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/23/20.
//

import UIKit

class WeatherCell : UITableViewCell {
    @IBOutlet weak var weatherBackgroundView : GradientView!
    @IBOutlet weak var weatherIcon : UIImageView!
    @IBOutlet weak var temperatureLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var cityNameLabel : UILabel!
}
