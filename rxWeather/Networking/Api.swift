//
//  Api.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/2/20.
//

import Foundation
import RxSwift
import RxCocoa

class Api  {
    
    static let shared = Api()
    let disposeBag = DisposeBag()
    
    func fetchCitys(by city: String) -> Observable<WeatherCity?> {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForFindCityAPI(city: cityEncoded) else {  return Observable.empty() }
        let resource = Resource<WeatherCity>(url: url)
        let search = URLRequest.load(ressource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: nil)
        return search.asObservable()
    }
    
    func getWeatherIcon(by code: String) -> Observable<UIImage?> {
        guard let url = URL.urlForWeatherIcon(code: code) else {  return Observable.just(UIImage()) }
        let resource = Resource<UIImage>(url: url)
        let download = URLRequest.downloadImage(ressource: resource).observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: nil)
        return  download.asObservable()
    }
    
    func fetchForecastWeather(by lat: Double, Lon: Double) -> Observable<WeatherForecastResult?>{
        let url = URL.urlForForecastAPI(lat: lat, lon: Lon)
        let resource = Resource<WeatherForecastResult>(url: url!)
        let search = URLRequest.load(ressource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: nil)
        return search.asObservable()
    }
    
}
