//
//  WeatherDetailsViewModel.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/27/20.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherDetailsViewModel {
    let citySubject = BehaviorRelay<Citys>(value: Citys.empty)
    var citySubjectObservable : Observable<Citys> {
        return citySubject.asObservable()
    }
    
    let weatherForecastSubject = BehaviorRelay<WeatherForecastResult>(value: WeatherForecastResult.empty)
    var weatherForecastObservable : Observable<WeatherForecastResult> {
        return weatherForecastSubject.asObservable()
    }
    
    let iconSubject = PublishSubject<UIImage>()
    var iconObservable : Observable<UIImage> {
        return iconSubject.asObservable()
    }
    
    let listIconBehavior = BehaviorRelay<[UIImage]>(value: [])
    var listIconObservable : Observable<[UIImage]> {
        return listIconBehavior.asObservable()
    }
    let dailyCollectionSubject = BehaviorRelay<[WeatherDaily]>(value: [])
    var dailyCollectionObservable : Observable<[WeatherDaily]> {
        return dailyCollectionSubject.asObservable()
    }

    let todayCollectionSubject = BehaviorRelay<[Double]>(value: [])
    var todayCollectionObservable : Observable<[Double]> {
        return todayCollectionSubject.asObservable()
    }

    let disposeBag = DisposeBag()
    
    var listWeather : [Double] = []
    
    var listTime : [String] = ["Morning", "Evening", "Night"]
    
    var todayListIcons: [UIImage] = [
        UIImage(named: "01d.png")!,
        UIImage(named: "02d.png")!,
        UIImage(named: "02d.png")!
    ]
    
    func getForecastWeather(lat: Double, lon: Double)-> Observable<WeatherForecastResult?>{
        let forecastObservable = Api.shared.fetchForecastWeather(by: lat, Lon: lon)
        forecastObservable.map{ data in
            if let data = data {
                if let data = data.daily.first?.temp {
                    self.listWeather.removeAll()
                    self.listWeather.append(data.morn)
                    self.listWeather.append(data.eve)
                    self.listWeather.append(data.night)
                }
                self.dailyCollectionSubject.accept(data.daily)
                self.todayCollectionSubject.accept(self.listWeather)
            }
        }.subscribe().disposed(by: disposeBag)
        return forecastObservable.asObservable()
    }
    
    func getWeatherIcon(code: String) ->Observable<UIImage?> {
       let iconObservable = Api.shared.getWeatherIcon(by: code)
        return iconObservable.asObservable()
//        iconObservable.subscribe(onNext : { icon in
//            if let icon = icon {
//                self.iconSubject.onNext(icon)
//            }
//        }).disposed(by: disposeBag)
    }
    
    func getDailyWeatherIcon(code: String) -> Observable<UIImage?> {
       let iconObservable = Api.shared.getWeatherIcon(by: code)
        iconObservable.map{ icon in
            if let icon = icon {
                self.todayListIcons.append(icon)
            }
            self.listIconBehavior.accept(self.todayListIcons)
        }.subscribe().disposed(by: self.disposeBag)
        return iconObservable.asObservable()
    }
    
    func getCountryAndCity(city: String, country: String) -> String {
        return city + ", " + country
    }
  
    
}
