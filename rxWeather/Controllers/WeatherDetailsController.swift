//
//  WeatherDetailsController.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/25/20.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

class WeatherDetailsController: UIViewController {
    
    
    let viewModel = WeatherDetailsViewModel()
    
    @IBOutlet weak var bannerView: GradientView!
    @IBOutlet weak var countryLabel : UILabel!
    @IBOutlet weak var tempLabel : UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherBackground: UIImageView!
    @IBOutlet weak var feelLikeLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var todaycollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.citySubjectObservable.subscribe(onNext: { details in
            guard let weatherMain = details.weather.first?.main else { return }
            self.setupView(weather: weatherMain)
            
            self.viewModel.getForecastWeather(lat: details.coord.lat, lon: details.coord.lon).subscribe(onNext : { data in
                if let data = data {
                    self.visibilityLabel.text = getVisibility(visibility: data.current.visibility)
                    self.sunriseLabel.text = getSunrise(date: data.current.sunrise)
                    self.sunsetLabel.text = getSunset(date: data.current.sunset)
                }
            }).disposed(by: self.viewModel.disposeBag)
  
            guard let codeIcon = details.weather.first?.icon else { return  }
            self.viewModel.getWeatherIcon(code: codeIcon).subscribe(onNext: { image in
                self.weatherIcon.image = image
                self.weatherBackground.image = image
            }).disposed(by: self.viewModel.disposeBag)
        
            self.countryLabel.text = self.viewModel.getCountryAndCity(city: details.name, country: details.sys.country)
            self.tempLabel.text = getTemperature(temp: details.main.temp)
            self.humidityLabel.text = getHumidity(humidity: details.main.humidity)
            self.pressureLabel.text = getPressure(pressure: details.main.pressure)
            self.feelLikeLabel.text = getFeelLike(temp: details.main.feels_like)
            self.tempMinLabel.text = getTempMin(min: details.main.temp_min)
            self.tempMaxLabel.text = getTempMax(max: details.main.temp_max)
            self.windLabel.text = getWind(wind: details.wind.speed)
            self.todayLabel.text = getToDayDate()
            self.setupMapView(with: details.coord.lat, lon: details.coord.lon)
            
        }).disposed(by: viewModel.disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex.subscribe (onNext: { index in
            switch index {
                case 0: self.collectionView.isHidden = true
                        self.todaycollectionView.isHidden = false
                case 1: self.collectionView.isHidden = false
                        self.todaycollectionView.isHidden = true
            default: break
            }
            self.updateWeatherCollection()
        }).disposed(by: viewModel.disposeBag)
         
        self.viewModel.dailyCollectionObservable.bind(to: self.collectionView.rx.items(cellIdentifier: "weatherCollectionCell", cellType: WeatherCollectionCell.self)){ row, data, cell in
            cell.weatherDayLabel.text = getDayName(day: data.dt)
            cell.temperatureLabel.text = getTemperature(temp: data.temp.day)
            cell.humidityLabel.text = getHumidity(humidity: data.humidity)
            guard let codeIcon = data.weather.first?.icon else { return  }
            self.viewModel.getDailyWeatherIcon(code: codeIcon).subscribe(onNext: { image in
                cell.weatherIcon.image = image
            }).disposed(by: self.viewModel.disposeBag)
        }.disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.todayCollectionObservable.bind(to: self.todaycollectionView.rx.items(cellIdentifier: "weatherCollectionCell", cellType: WeatherCollectionCell.self)){ row, data, cell in
            cell.weatherDayLabel.text = self.viewModel.listTime[row]
            cell.weatherIcon.image = self.viewModel.todayListIcons[row]
            cell.temperatureLabel.text = getTemperature(temp: self.viewModel.listWeather[row])
        }.disposed(by: self.viewModel.disposeBag)
        
    }
    
    private func setupView(weather : String) {
        addGradient(colors:[getColor(from: weather),UIColor.white], view: self.bannerView)

        let flowLayout = UICollectionViewFlowLayout()
        let size = (collectionView.frame.size.width - CGFloat(30)) / CGFloat(3)
        flowLayout.itemSize = CGSize(width: size, height: size)
        flowLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        let todayflowLayout = UICollectionViewFlowLayout()
        let todaysize = (todaycollectionView.frame.size.width - CGFloat(30)) / CGFloat(3)
        todayflowLayout.itemSize = CGSize(width: todaysize, height: todaysize)
        todayflowLayout.scrollDirection = .horizontal
        todaycollectionView.setCollectionViewLayout(todayflowLayout, animated: true)
    }
    
    private func setupMapView(with lat : Double , lon : Double) {
        let annotation = MKPointAnnotation()
        let locationCoord =  CLLocation(latitude: lat, longitude: lon)
        self.mapView.centerToLocation(locationCoord)
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.mapView.addAnnotation(annotation)
    }
    
    private func updateWeatherCollection() {
        self.collectionView.reloadData()
        self.todaycollectionView.reloadData()
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }

}

