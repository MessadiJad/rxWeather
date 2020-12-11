//
//  sky.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/8/20.
//

import UIKit
import SpriteKit


class SkyView: UIView {
    var constellationLayer: CAEmitterLayer!
    
    static let shared = SkyView()
    let dateFormatter = DateFormatter()

    func initWith(weather: String, timeZone: String, view: UIView) {
        
        guard let gradientLayer = view.layer as? CAGradientLayer else { return }
        self.addCondition(with: weather, view: view)
        constellationLayer = createConstellationLayer(view: view)

        switch getCurrentHoure(timeZone: timeZone) {
        case "Day":
            if weather == "Clouds" ||  weather == "Fog" {
                gradientLayer.colors = [UIColorFromRGB(rgbValue: 0x4C5158).cgColor,UIColorFromRGB(rgbValue: 0x8CBDD6).cgColor]
            }else {
                gradientLayer.colors = [UIColorFromRGB(rgbValue: 0x3399FF).cgColor,UIColorFromRGB(rgbValue: 0x33CCFF).cgColor]
            }
            
        case "Evening": gradientLayer.colors = [UIColorFromRGB(rgbValue: 0x0c1445).cgColor,UIColorFromRGB(rgbValue: 0x5c54a4).cgColor]
           view.layer.addSublayer(constellationLayer)
        case "Night": gradientLayer.colors = [UIColorFromRGB(rgbValue: 0x000428).cgColor,UIColorFromRGB(rgbValue: 0x004E92).cgColor]
            view.layer.addSublayer(constellationLayer)
        default: break
        }
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x:0, y:0.6)
        gradientLayer.cornerRadius = 15
        gradientLayer.type = .axial
        gradientLayer.locations = [0, 2]
        gradientLayer.shadowColor = UIColor.white.cgColor
        gradientLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        gradientLayer.shadowRadius = 12.0
        gradientLayer.shadowOpacity = 1
    }
    
    func getCurrentHoure(timeZone: String) -> String {
        let currentDate = Date()
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dateFormatter.string(from: currentDate)

        guard let date = dateFormatter.date(from: dateString) else {return ""}
        
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 6..<17 : return "Day"
        case 17..<22 : return "Evening"
        default: return "Night"
        }
    }
    
    private func addCondition(with weather : String, view : UIView) {
        switch weather {
        case "Rain": addRain(view: view)
        case "Snow":addSnow(view: view)
        default: break
        }
    
    }
    
    func createConstellationLayer(view : UIView) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.center.x, y: view.center.y)
        emitter.emitterShape = .rectangle
        emitter.emitterSize = CGSize(width: view.frame.size.width * 2, height: view.frame.size.height * 2)
        let cell = CAEmitterCell()
        cell.lifetime = 2000.0
        cell.scale = 0.1
        cell.scaleRange = 0.09
        
        cell.contents = UIImage(named: "star-circle.png")!.cgImage
        cell.birthRate = 1
        emitter.emitterCells = [cell]
        return emitter
    }
    
    private func addRain(view : UIView) {
        let skView = SKView(frame: view.frame)
        skView.backgroundColor = .clear
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        skView.presentScene(scene)
        skView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.removeFromParent()
        let emitterNode = SKEmitterNode(fileNamed: "Rain.sks")!
        scene.addChild(emitterNode)
        emitterNode.position.y = scene.frame.maxY
        emitterNode.particlePositionRange.dx = scene.frame.width
        view.addSubview(skView)
    }
    
    private func addSnow(view : UIView) {
        let skView = SKView(frame: view.frame)
        skView.backgroundColor = .clear
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        skView.presentScene(scene)
        skView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.removeFromParent()
        let emitterNode = SKEmitterNode(fileNamed: "Snow.sks")!
        scene.addChild(emitterNode)
        emitterNode.position.y = scene.frame.maxY
        emitterNode.particlePositionRange.dx = scene.frame.width
        view.addSubview(skView)
    }
    
}
