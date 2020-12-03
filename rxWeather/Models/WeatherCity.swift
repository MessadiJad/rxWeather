//
//  WeatherCity.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/30/20.
//

import Foundation

struct WeatherCity: Decodable{
    let message : String
    let cod : String
    let count : Int
    let list : [Citys]
}

struct Citys : Decodable {
    let name : String
    let main : Main
    let coord : CityCoord
    let wind : Wind
    let weather : [Weather]
    let sys : System
    let dt : Int
}

struct CityCoord : Decodable {
    let lat : Double
    let lon : Double
}

struct System : Decodable {
    let country : String
}

struct Main : Decodable {
    let temp : Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct Wind : Decodable {
    let speed : Double
    let deg : Double
}

struct Weather : Decodable {
    let main : String
    let description : String
    let icon : String
}

extension Citys {
    static var empty: Citys {
        return Citys(name: "", main: Main(temp: 0.0, feels_like: 0.0, temp_min: 0.0, temp_max: 0.0, pressure: 0.0, humidity: 0.0), coord: CityCoord(lat: 0.0, lon: 0.0), wind: Wind(speed: 0.0, deg: 0.0), weather: [], sys: System(country: ""), dt: 0)
    }
}
