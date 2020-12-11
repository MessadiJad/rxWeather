//
//  WeatherCollectionCell.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/27/20.
//

import UIKit

class WeatherCollectionCell : UICollectionViewCell {
    @IBOutlet weak var weatherDayLabel : UILabel!
    @IBOutlet weak var weatherIcon : UIImageView!
    @IBOutlet weak var temperatureLabel : UILabel!
    @IBOutlet weak var humidityLabel : UILabel!
    @IBOutlet weak var separatorView: UIView!
}
