//
//  WeatherForecastResult.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/27/20.
//

import Foundation

struct WeatherForecastResult: Decodable {
    let timezone : String
    let timezone_offset: Double
    let current : WeatherForecastCity
    let daily : [WeatherDaily]
}

struct WeatherForecastCity: Decodable {
    let dt: Double
    let sunrise: Int
    let sunset: Int
    let visibility: Double
    let dew_point: Double
    let uvi: Double
    let clouds: Double
}

struct WeatherForecast : Decodable {
    let main : String
    let description : String
    let icon : String
}

struct WeatherDaily: Decodable {
    let dt : Int
    let temp: Time
    let humidity: Double
    let weather: [WeatherForecast]
}

struct Time: Decodable  {
    let day : Double
    let morn : Double
    let eve : Double
    let night : Double
}

extension WeatherForecastResult {
    static var empty: WeatherForecastResult {
        return WeatherForecastResult(timezone: "", timezone_offset: 0.0, current: WeatherForecastCity(dt: 0.0, sunrise: 0, sunset: 0, visibility: 0.0, dew_point: 0.0, uvi: 0.0, clouds: 0.0), daily: [])
    }
    
}
