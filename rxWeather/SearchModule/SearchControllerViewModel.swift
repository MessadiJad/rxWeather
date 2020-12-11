//
//  SearchControllerViewModel.swift
//  rxWeather
//
//  Created by Jad Messadi on 12/4/20.
//

import Foundation
import RxCocoa
import RxSwift

class SearchControllerViewModel {
    let disposeBag = DisposeBag()
    
    func submitSearch(by item : Citys) {
        WeatherListViewModel.cityListBehavior.add(element:item)
    }
}
