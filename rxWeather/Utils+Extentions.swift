//
//  Utils.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/24/20.
//

import UIKit
import RxCocoa
import RxSwift
import MapKit

var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func calculateCelsius(fahrenheit: Double) -> String {
    let celsius = (fahrenheit - 32) * 5 / 9
    return String(format: "%.0f", celsius)
}

func convertDate(date: Int) -> String {
    let epocTime = TimeInterval(date)
    let dates = Date(timeIntervalSince1970: epocTime)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.dateFormat = "HH:mm"
    let timeStamp = dateFormatter.string(from: dates)
    return timeStamp
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

func getToDayDate() -> String {
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
    let date = Date()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "EEE, dd MMM"
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func getTemperature(temp: Double) -> String {
    return calculateCelsius(fahrenheit: temp) + "°"
}

func getWind(wind: Double) -> String {
    return String(format: "%.0f", wind) + " km/h"
}

func getVisibility(visibility: Double) -> String {
    return String(format: "%.0f", visibility.convert(from: .meters, to: .kilometers)) + " km"
}

func getHumidity(humidity: Double) -> String {
    return String(format: "%.0f", humidity) + " %"
}

func getPressure(pressure: Double) -> String {
    return String(format: "%.0f", pressure) + " hPa"
}

func getFeelLike(temp: Double) -> String {
    return calculateCelsius(fahrenheit: temp)
}

func getSunrise(date: Int) -> String {
    return convertDate(date: date)
}

func getSunset(date: Int) -> String {
    return convertDate(date: date)
}

func getTempMax(max: Double) -> String {
    return calculateCelsius(fahrenheit: max) + "°"
}

func getTempMin(min: Double) -> String {
    return calculateCelsius(fahrenheit: min)
}

func getDayName(day: Int) -> String {
    let epocTime = TimeInterval(day)
    let date = Date(timeIntervalSince1970: epocTime)
    return date.dayOfWeek()!
    
}

extension Double {
    func convert(from originalUnit: UnitLength, to convertedUnit: UnitLength) -> Double {
        return Measurement(value: self, unit: originalUnit).converted(to: convertedUnit).value
    }
}

func getColor(from weather : String) -> UIColor{
    switch weather {
    case "Clear": return UIColorFromRGB(rgbValue: 0x7cc7d9)
    case "Clouds": return UIColorFromRGB(rgbValue: 0xb0a99f)
    default:  return UIColorFromRGB(rgbValue: 0xb0a99f)
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}

func addGradient(colors: [UIColor] = [.blue, .white], view :UIView) {
    guard let gradientLayer = view.layer as? CAGradientLayer else { return }
    gradientLayer.colors = colors.map{ $0.cgColor }
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x:0, y:0.6)
    gradientLayer.cornerRadius = 15
    gradientLayer.type = .axial
    gradientLayer.locations = [0, 2]
}

class GradientView: UIView {
    override class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
}


extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}


extension UISearchBar {
    
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                textField.textColor = newValue
            }
        }
    }
}

extension UIBarButtonItem {
    var isHidden: Bool {
        get {
            return !isEnabled && tintColor == .clear
        }
        set {
            tintColor = newValue ? .clear : nil
            isEnabled = !newValue
        }
    }
}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
