//
//  URLRequest+Extensions.swift
//  rxWeather
//
//  Created by Jad Messadi on 11/23/20.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    
    static func load<T: Decodable>(ressource:Resource<T>) -> Observable<T?> {
        return Observable.from([ressource.url])
            .flatMap{ url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map{ data -> T? in
                return try? JSONDecoder().decode(T.self, from: data)
            }.asObservable()
    }
    
    static func downloadImage(ressource:Resource<UIImage>) -> Observable<UIImage?> {
        return URLSession.shared.rx
            .data(request: URLRequest(url: ressource.url))
            .map { data in UIImage(data: data) }
            .catchErrorJustReturn(nil)
    }
    
}
