//
//  WeatherListController.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/23/20.
//

import UIKit
import RxSwift
import RxCocoa


class WeatherListController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var myPositionButton : UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = WeatherListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: { name in
            self.viewModel.fetchCitys(by: name).subscribe(onNext: { city in
                if let city = city {
                    self.viewModel.searchBehavior.accept(city.list)
                }
                self.updateList()
            }).disposed(by: self.viewModel.disposeBag)
        }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.searchBehavior.bind(to: tableView.rx.items) {table, row, model  in
            self.makeCells(with: model, from: table)
        }.disposed(by: self.viewModel.disposeBag)
        
        tableView.rx.modelSelected(Citys.self).subscribe(onNext : { item in
            if self.viewModel.searching {
                self.viewModel.submitSearch(by: item)
                self.searchController.isActive = false
                self.updateList()
            }else{
                self.performSegue(withIdentifier: "showDetails", sender: self)
            }
        }).disposed(by: self.viewModel.disposeBag)
    }
    
    func setupView() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
    }
    
    private func makeCells(with model: Citys, from table: UITableView) -> UITableViewCell{
        if self.viewModel.searching {
            guard let searchCell = table.dequeueReusableCell(withIdentifier: "searchCell") else { fatalError("search cell does not exist") }
            searchCell.textLabel?.text = model.name + ", " + model.sys.country
            return searchCell
        }else {
            guard let weatherCell = table.dequeueReusableCell(withIdentifier: "weatherCell") as? WeatherCell else { fatalError("weather cell does not exist") }
            if let weatherMain = model.weather.first?.main {
                addGradient(colors:[getColor(from: weatherMain), UIColor.white], view: weatherCell.weatherBackgroundView)
            }
            weatherCell.temperatureLabel.text = getTemperature(temp: model.main.temp)
            weatherCell.cityNameLabel.text = model.name
            if let codeIcon = model.weather.first?.icon {
                self.viewModel.fetchWeatherIcon(by: codeIcon).subscribe(onNext : { image in
                    weatherCell.weatherIcon.image = image
                }).disposed(by: self.viewModel.disposeBag)}
            weatherCell.timeLabel.text = convertDate(date: model.dt)
            return weatherCell
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.viewModel.clearSearch()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.cancelSearch()
        updateList()
    }
    
    private func updateList() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            guard let nc = segue.destination as? UINavigationController else { fatalError("Navigation controller does not exist") }
            guard let vc = nc.viewControllers.first as? WeatherDetailsController else { fatalError("WeatherDetailsController does not exist") }
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            vc.viewModel.citySubject.accept(self.viewModel.searchBehavior.value[indexPath.row])
        }
    }
}
