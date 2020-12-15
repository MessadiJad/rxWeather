//
//  HomeViewController.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/3/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation


class HomeViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, WeatherListControllerDelegate, SearchButtonDelegate {

  
    let viewModel = HomeViewModel()
    
    @IBOutlet weak var countryLabel : UILabel!
    @IBOutlet weak var tempLabel : UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var feelLikeLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var todayCollectionView: UICollectionView!
    
    lazy var searchController = UISearchController(searchResultsController:nil)
    lazy var searchCitysVC = storyboard?.instantiateViewController(withIdentifier: "searchResultsTableViewController") as! SearchViewController
    lazy var listCitysVC = storyboard?.instantiateViewController(withIdentifier: "WeatherCitysListViewController") as! WeatherListController

    override func viewDidLoad() {
        super.viewDidLoad()

        initLocation()
        initSearchBar()
        self.viewModel.getCurrentCity().subscribe(onNext: { city in
            
            if let list = city?.list.first {
                guard let weather = list.weather.first?.main else { return }
                self.setupView(with: weather)
                
                self.viewModel.getCurrentForecastWeather(lat: list.coord.lat, lon: list.coord.lon).subscribe(onNext : { data in
                    if let data = data {
                        self.sunriseLabel.text = getSunrise(date: data.current.sunrise)
                        self.sunsetLabel.text = getSunset(date: data.current.sunset)
                    }
                }).disposed(by: self.viewModel.disposeBag)
                
                self.countryLabel.text = list.name
                self.tempLabel.text = getTemperature(temp: list.main.temp)
                self.tempMaxLabel.text = getTempMax(max: list.main.temp_max)
                self.weatherConditionLabel.text = weather
                self.feelLikeLabel.text = getTemperature(temp: list.main.feels_like)
                guard let codeIcon = list.weather.first?.icon else { return }                
                self.viewModel.getWeatherIcon(code: codeIcon).subscribe(onNext: { image in
                    self.currentWeatherImageView.image = image
                }).disposed(by: self.viewModel.disposeBag)
            }
        }).disposed(by: self.viewModel.disposeBag)
        
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: { name in
            self.viewModel.fetchCitys(by: name).subscribe(onNext: { city in
                if let city = city {
                    self.searchCitysVC.searchResults.accept(city.list)
                }
            }).disposed(by: self.viewModel.disposeBag)
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.todayCurrentCollectionObservable.bind(to: self.todayCollectionView.rx.items(cellIdentifier: weatherCollectionCellId, cellType: WeatherCollectionCell.self)){ row, data, cell in
            cell.weatherDayLabel.text = self.viewModel.listTime[row]
            cell.weatherIcon.image = self.viewModel.todayListIcons[row]
            cell.temperatureLabel.text = getTemperature(temp: self.viewModel.currentWeather[row])
            if row == 2 {
                cell.separatorView.isHidden = true
            }else {
                cell.separatorView.isHidden = false
            }
        }.disposed(by: self.viewModel.disposeBag)
        
    }
        
    private func setupView(with weather : String) {
        
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.minimumScaleFactor = 0.5
        
        SkyView.shared.initWith(weather: weather, timeZone: localTimeZoneIdentifier, view: self.view)
        
        let todayflowLayout = UICollectionViewFlowLayout()
        let todaysize = (todayCollectionView.frame.size.width - CGFloat(30)) / CGFloat(3)
        todayflowLayout.itemSize = CGSize(width: todaysize, height: todaysize)
        todayflowLayout.scrollDirection = .horizontal
        todayCollectionView.setCollectionViewLayout(todayflowLayout, animated: false)
    }
    
    private func initSearchBar() {
        searchController = UISearchController(searchResultsController: searchCitysVC)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search city"
        searchController.searchResultsUpdater = searchCitysVC
        searchController.searchBar.delegate = searchCitysVC
        searchCitysVC.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .white
        searchController.searchBar.textColor = .white
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        self.definesPresentationContext = false
    }
    
    private func initLocation() {
        self.viewModel.manager.requestWhenInUseAuthorization()
        self.viewModel.manager.startUpdatingLocation()
    }
    
    @IBAction func searchAction(sender: UIBarButtonItem) {
        searchButton.isHidden = true
        present(searchController, animated: true, completion: nil)
    }
    
    func searchCityDidSelect(elementExist : Bool) {
        searchCitysVC.delegate?.didButtonShown(stats: false)
        if !elementExist {
            present(searchController, animated: true, completion: nil)
        }else {
            listCitysVC.collectionView.isHidden = false
            listCitysVC.layer.removeFromSuperlayer()
            listCitysVC.findCitysButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.listCitysVC = segue.destination as! WeatherListController
        self.listCitysVC.delegate = self
    }
    
    func didButtonShown(stats: Bool) {
        if stats {
            searchButton.isHidden = false
            searchButton.tintColor = .white
        }else {
            searchButton.isHidden = true
        }
    }
    

}
