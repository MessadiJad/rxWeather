//
//  WeatherListController.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/23/20.
//

import UIKit
import RxSwift
import RxCocoa
protocol WeatherListControllerDelegate:class {
    func searchCityDidSelect(elementExist : Bool)
}

class WeatherListController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var findCitysButton : UIButton!
    var delegate: WeatherListControllerDelegate?

    let viewModel = WeatherListViewModel()
    let layer = CAShapeLayer.init()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findCitysButton.addTarget(self, action: #selector(WeatherListController.findCity), for: .touchUpInside)

        self.setupView()
      
        self.viewModel.cityListObservable.bind(to: self.collectionView.rx.items(cellIdentifier: "citysCollectionCell", cellType: CityCollectionCell.self)){ row, data, cell in
            self.delegate?.searchCityDidSelect(elementExist: true)

            cell.tempLabel.text = getTemperature(temp:data.main.temp)
            cell.locationLabel.text = data.name
            cell.weatherConditionLabel.text = data.weather.first?.main
            cell.minMaxLabel.text = getTemperature(temp: data.main.temp_max) + " " + getTemperature(temp: data.main.temp_min)
            if let weather = data.weather.first?.main {
                SkyView.shared.initWith(weather: weather, timeZone: "", view: cell.contentView)
            }
            guard let icon = data.weather.first?.icon else { return }
            
            self.viewModel.fetchWeatherIcon(by: icon).subscribe(onNext: { image in
                cell.weatherIcon.image = image
            }).disposed(by: self.viewModel.disposeBag)
           
        }.disposed(by: self.viewModel.disposeBag)

        collectionView.rx.modelSelected(Citys.self).subscribe(onNext : { item in
            self.performSegue(withIdentifier: showDetailsSegueId, sender: self)
        }).disposed(by: self.viewModel.disposeBag)
    }
    
    private func setupView() {
        let rect = CGRect.init(origin: CGPoint.init(x: 10, y: 10), size: CGSize.init(width: view.frame.width - CGFloat(30), height:150))
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 15)
        layer.path = path.cgPath;
        layer.strokeColor = UIColor.white.cgColor
        layer.lineDashPattern = [3,3]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        self.view.layer.addSublayer(layer)
        
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
        if segue.identifier == showDetailsSegueId {
            guard let nc = segue.destination as? UINavigationController else { fatalError("Navigation controller does not exist") }
            guard let vc = nc.viewControllers.first as? WeatherDetailsController else { fatalError("WeatherDetailsController does not exist") }
            guard let indexPath = self.collectionView.indexPathsForSelectedItems?.first else { return }
            vc.viewModel.citySubject.accept(WeatherListViewModel.cityListBehavior.value[indexPath.row])
        }
    }
    
    @objc func findCity() {
        delegate?.searchCityDidSelect(elementExist: false)
    }
}
