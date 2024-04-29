//
//  ImageDownLoader.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/27.
//

import Foundation
import RxSwift


//MARK: - 이미지 다운로드 헬퍼
class ImageDownLoader {
    static let shared = ImageDownLoader()
    private init(){}
    
    //이미지 캐시용
    private let cache = NSCache<NSString,NSData>()
    
    
    func download(imageUrl : String, completion : @escaping(Data?,Error?) -> ()){
        //캐시가 되어 있다면 바로 리턴
        if let imageData = cache.object(forKey: imageUrl as NSString) {
            completion(imageData as Data,nil)
            return
        }
        
        
        guard let URL = URL(string: imageUrl) else {
            completion(nil,CustomError.error("invalid url"))
            return
        }
        
        
        
        let task = URLSession.shared.downloadTask(with: URL) { [unowned self] url, response, error in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                
                completion(nil, CustomError.error(
                    "HTTP Error - status code \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                ))
                return
            }
            
            guard let url = url else {
                completion(nil, CustomError.error("invalid url"))
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                self.cache.setObject(data as NSData, forKey: imageUrl as NSString)
                completion(data,nil)
            }
            catch( let error ) {
                completion(nil, error)
            }
        }
        
        task.resume()
        
    }
}







