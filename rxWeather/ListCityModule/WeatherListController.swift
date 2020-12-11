//
//  WeatherListController.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/23/20.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherListController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!

    let viewModel = WeatherListViewModel()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

        self.viewModel.cityListObservable.bind(to: self.collectionView.rx.items(cellIdentifier: "citysCollectionCell", cellType: CityCollectionCell.self)){ row, data, cell in
            cell.tempLabel.text = getTemperature(temp:data.main.temp)
            cell.locationLabel.text = data.name
            cell.weatherConditionLabel.text = data.weather.first?.main
            cell.minMaxLabel.text = getTemperature(temp: data.main.temp_max) + " " + getTemperature(temp: data.main.temp_min)
            if let weather = data.weather.first?.main {
                SkyView.shared.initWith(weather: weather, timeZone: "", view: cell.backView)
            }
            guard let icon = data.weather.first?.icon else { return }
            
            self.viewModel.fetchWeatherIcon(by: icon).subscribe(onNext: { image in
                cell.weatherIcon.image = image
                
                cell.contentView.layer.shadowColor = UIColor.white.cgColor
                cell.contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                cell.contentView.layer.shadowRadius = 12.0
                cell.contentView.layer.shadowOpacity = 0.7
            }).disposed(by: self.viewModel.disposeBag)
           
        }.disposed(by: self.viewModel.disposeBag)

        collectionView.rx.modelSelected(Citys.self).subscribe(onNext : { item in
            self.performSegue(withIdentifier: "showDetails", sender: self)
        }).disposed(by: self.viewModel.disposeBag)
    }
    
    private func setupView() {
       
        let flowLayout = UICollectionViewFlowLayout()
        let size = (collectionView.frame.size.width - CGFloat(50)) / CGFloat(2)
        flowLayout.itemSize = CGSize(width: size, height: 150)
        flowLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
    }
    
    func updateList() {
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            guard let nc = segue.destination as? UINavigationController else { fatalError("Navigation controller does not exist") }
            guard let vc = nc.viewControllers.first as? WeatherDetailsController else { fatalError("WeatherDetailsController does not exist") }
            guard let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return }
            vc.viewModel.citySubject.accept(WeatherListViewModel.cityListBehavior.value[indexPath.row])
        }
    }
}
