//
//  WeatherListViewModel.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/3/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

class WeatherListViewModel {
    
    let searchBehavior = BehaviorRelay<[Citys]>(value: [])
    var searchObservable : Observable<[Citys]> {
        return searchBehavior.asObservable()
    }
    var searching = false
    var listOfCity : [Citys] = []
    let manager = CLLocationManager()
    let disposeBag = DisposeBag()
    
    func fetchCitys(by name : String) -> Observable<WeatherCity?> {
        let wcObservable = Api.shared.fetchCitys(by: name)
        return wcObservable.asObservable()
    }
    
    func submitSearch(by item : Citys) {        
        searchBehavior.accept([])
        searchBehavior.add(element:item)
        listOfCity.append(item)
        searchBehavior.accept(self.listOfCity)
        searching = false
    }
    
    func fetchWeatherIcon(by code: String) -> Observable<UIImage?> {
        let imageObservable = Api.shared.getWeatherIcon(by: code)
        return imageObservable.asObservable()
    }
    
    func clearSearch(){
        searching = true
        searchBehavior.accept([])
    }
    
    func cancelSearch(){
        searching = false
        searchBehavior.accept(listOfCity)
    }
}
