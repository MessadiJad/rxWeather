//
//  CityCollectionCell.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/7/20.
//

import UIKit

class CityCollectionCell : UICollectionViewCell {
    @IBOutlet weak var tempLabel : UILabel!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var weatherConditionLabel : UILabel!
    @IBOutlet weak var weatherIcon : UIImageView!
    @IBOutlet weak var minMaxLabel : UILabel!
    @IBOutlet weak var backView : GradientView!
    @IBOutlet weak var collectionView : UICollectionView!

}
