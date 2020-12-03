//
//  URL+Extensions.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/23/20.
//

import Foundation

extension URL {
    
    static func urlForFindCityAPI(city: String) -> URL? {
        return URL(string: "\(BASE_URL)data/2.5/find?q=\(city)&APPID=\(APPID)&units=\(UNITS)")
    }
    
    static func urlForForecastAPI(lat: Double, lon: Double) -> URL? {
        return URL(string: "\(BASE_URL)data/2.5/onecall?lat=\(lat)&lon=\(lon)&APPID=\(APPID)&units=\(UNITS)")
    }
    
    static func urlForWeatherIcon(code: String) -> URL? {
        return URL(string:"\(BASE_URL)/img/w/\(code).png")
    }
    
}
