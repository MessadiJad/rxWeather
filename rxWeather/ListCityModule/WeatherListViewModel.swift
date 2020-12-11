//
//  WeatherListViewModel.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/3/20.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherListViewModel {
    
    static let cityListBehavior = BehaviorRelay<[Citys]>(value: [])
    var cityListObservable : Observable<[Citys]> {
        return WeatherListViewModel.cityListBehavior.asObservable()
    }
    var listOfCity : [Citys] = []
    let disposeBag = DisposeBag()
    
    func fetchWeatherIcon(by code: String) -> Observable<UIImage?> {
        let imageObservable = Api.shared.getWeatherIcon(by: code)
        return imageObservable.asObservable()
    }
    
}
