//
//  HomeViewModel.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/4/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

class HomeViewModel {
    
    let searchBehavior = BehaviorRelay<[Citys]>(value: [])
    var searchObservable : Observable<[Citys]> {
        return searchBehavior.asObservable()
    }
    
    let todayCurrentCollectionSubject = BehaviorRelay<[Double]>(value: [])
    var todayCurrentCollectionObservable : Observable<[Double]> {
        return todayCurrentCollectionSubject.asObservable()
    }
    var currentWeather : [Double] = []
    
    var listTime : [String] = ["Morning", "Evening", "Night"]
    
    var todayListIcons: [UIImage] = [
        UIImage(named: "01d.png")!,
        UIImage(named: "02d.png")!,
        UIImage(named: "01n.png")!
    ]
    let manager = CLLocationManager()
    let disposeBag = DisposeBag()
    
    func fetchCitys(by name : String) -> Observable<WeatherCity?> {
        let wcObservable = Api.shared.fetchCitys(by: name)
        return wcObservable.asObservable()
    }
    
    func getCurrentCity() -> Observable<WeatherCity?>  {
        let currentCity = self.manager.rx
            .placemark
            .flatMap{ val -> Observable<WeatherCity?> in
                return Api.shared.fetchCitys(by: val.locality!)
            }
        return currentCity.asObservable()
    }
    
    func getCurrentForecastWeather(lat: Double, lon: Double)-> Observable<WeatherForecastResult?>{
        let forecastObservable = Api.shared.fetchForecastWeather(by: lat, Lon: lon)
        forecastObservable.map{ data in
            if let data = data {
                if let data = data.daily.first?.temp {
                    self.currentWeather.removeAll()
                    self.currentWeather.append(data.morn)
                    self.currentWeather.append(data.eve)
                    self.currentWeather.append(data.night)
                }
                self.todayCurrentCollectionSubject.accept(self.currentWeather)
            }
        }.subscribe().disposed(by: disposeBag)
        return forecastObservable.asObservable()
    }
    
    func getWeatherIcon(code: String) ->Observable<UIImage?> {
       let iconObservable = Api.shared.getWeatherIcon(by: code)
        return iconObservable.asObservable()
    }
}
