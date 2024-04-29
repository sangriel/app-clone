//
//  BaseNetworkService.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/27.
//

import Foundation
import RxSwift
import RxCocoa


enum HttpMethod : String {
    case GET
    case POST
    case DELETE
    case PUT
}


//MARK: - 네트워킹시 사용되는 중복소스 제거를 위하여 베이스 클라스를 사용
class BaseNetworkService  {
    
    //MARK: - HttpMethod에 따른 query 혹은 body 추가하는 함수 + tdd test용
    func getRequestURL(method : HttpMethod, baseUrl : String, parameter : [String : Any] ) -> (URLRequest?,CustomError?) {
        
        var urlComponents = URLComponents(string: baseUrl)
        //Get과 Delete의 경우 쿼리로써 인자를 전달
        if method == .DELETE || method == .GET {
            
            for (key,value) in parameter {
                let queryItem = URLQueryItem(name: key, value: String(describing: value ) )
                urlComponents?.queryItems?.append(queryItem)
            }
        }
        
        
        guard let url = urlComponents?.url else {
            return (nil,CustomError.error("unable to parse url Request") )
        }
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = method.rawValue
        
        //Post 와 Put의 경우 바디로서 인자 전달
        if method == .POST || method == .PUT {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
                return (nil,CustomError.error("http body making failed"))
            }
            requestUrl.httpBody = httpBody
        }
        
        
        return (requestUrl,nil)
    }
    
    
    func execute<T : Decodable>(method : HttpMethod,baseUrl : String,parameter : [String : Any]) -> Observable<T> {
        
        return Observable.create { [weak self] seal in
            guard let self = self else {
                seal.onError(CustomError.error("self deallocated"))
                return Disposables.create()
            }
            
            let (requestUrl,err) = self.getRequestURL(method: method, baseUrl: baseUrl, parameter: parameter)
            guard let requestUrl = requestUrl else {
                seal.onError(err!)
                return Disposables.create()
            }
            
            //네트워킹 시작
            let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
                
                if let error = error {
                    seal.onError(error)
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    seal.onError(CustomError.error(
                        "HTTP Error - status code \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                    ))
                    return
                }
                
                guard let data = data, let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                    seal.onError(CustomError.error("data null or unable to decode data with \(T.self)"))
                    return
                }
                seal.onNext(decoded)
                seal.onCompleted()
            }
            task.resume()
            
            return Disposables.create{
                task.cancel()
            }
        }
    }
}


