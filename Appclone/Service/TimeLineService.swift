//
//  TimeLineService.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/27.
//

import Foundation
import RxSwift
import RxCocoa




//MARK: -스트링을 직접 사용하는 것 보다 enum을 활용하여 오타를 최소화하기 위해서 사용
enum FetchDirection : String {
    case up
    case center
    case down
}

//MARK: -Rxswift에서 내보내줄 Error를 편하게 사용하게 위해서 사용 
enum CustomError : Error {
    case error(String)
}

//MARK: - 향후 테스트 케이스를 위한 프로토콜
protocol TimeLineServiceDelegate  {
    func fetch(base_time : String, time_size : Int, direction : FetchDirection) -> Observable<TimeLineModel>
}



class TimeLineService : TimeLineServiceDelegate {
    
    private let baseUrl : String = "http://item.assignment.dev-k8s.buzzni.net/timeline?"
    private let baseNetWorkService = BaseNetworkService()
    
    
    
    func fetch(base_time: String, time_size: Int, direction: FetchDirection) -> Observable<TimeLineModel> {
        let param : [String : Any] = ["platform" : "ios",
                                      "time_size" : time_size,
                                      "base_time" : base_time,
                                      "direction" : direction.rawValue]
        return baseNetWorkService.execute(method: .GET, baseUrl: baseUrl, parameter: param)
        
        
       
    }
}


//return Observable.create { [weak self] seal in
//    guard let self = self else {
//        seal.onError(CustomError.error("self deallocated"))
//        return Disposables.create()
//    }
//
//    var urlComponents = URLComponents(string: self.baseUrl)
//    let platformQuery = URLQueryItem(name: "platform", value: "ios")
//    let base_time = URLQueryItem(name: "base_time", value: base_time)
//    let time_size = URLQueryItem(name: "time_size", value: String(time_size))
//    let direction = URLQueryItem(name: "direction", value: direction.rawValue)
//
//    urlComponents?.queryItems?.append(platformQuery)
//    urlComponents?.queryItems?.append(base_time)
//    urlComponents?.queryItems?.append(time_size)
//    urlComponents?.queryItems?.append(direction)
//
//
//
//    guard let url = urlComponents?.url else {
//        seal.onError(CustomError.error("unable to parse url Request"))
//        return Disposables.create()
//    }
//    var requestUrl = URLRequest(url: url)
//    requestUrl.httpMethod = "GET"
//
//    let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
//        guard let data = data, let decoded = try? JSONDecoder().decode(T.self, from: data) else {
//            seal.onError(CustomError.error("data null or unable to decode data with \(T.self)"))
//            return
//        }
//
//        seal.onNext(decoded)
//    }
//    task.resume()
//
//    return Disposables.create{
//        task.cancel()
//    }
//}

