//
//  TimeLineModel.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/27.
//

import Foundation






struct TimeLineModel : Decodable {
    
    var msg : String
    var version : Double
    var success : Bool
    
    var before_live : [TimeLineItemListModel]
    var live : [TimeLineItemListModel]
    var after_live : [TimeLineItemListModel]
    var is_continues : Int
    
    
    enum CodingKeys: CodingKey { case msg, version, result, success }
    
    enum ResultKeys: CodingKey { case before_live, live, after_live, is_continues  }
    
    
    init(from decoder: Decoder) throws {
        let rootContainer   = try decoder.container(keyedBy: CodingKeys.self)
        try msg       =  rootContainer.decode(String.self,
                                              forKey: .msg)
        try version            =  rootContainer.decode(Double.self,
                                                       forKey: .version)
        
        
        let resultContainer = try rootContainer.nestedContainer(keyedBy: ResultKeys.self, forKey: .result)
        
        try is_continues = resultContainer.decode(Int.self, forKey: .is_continues)
        
        
        try before_live = resultContainer.decode([TimeLineItemListModel].self, forKey: .before_live)
        
        try live = resultContainer.decode([TimeLineItemListModel].self, forKey: .live)
        
        try after_live = resultContainer.decode([TimeLineItemListModel].self, forKey: .after_live)
        
        
        try success = rootContainer.decode(Bool.self, forKey: .success)
    }
    
    
    
    
    //before_live,live,after_live의 data 배열 안에 있는 오브젝트
    struct TimeLineItemListModel : Decodable {
        var listCount : Int?
        var data : [TimeLineItemModel]?
        var time : String
        var month : Int?
        var day : Int?
        var weekday_eng : String?
        var weekday_kor : String?
        var type : String?
        
        
        enum CodingKeys : CodingKey { case count, data, time, month, day, weekday_eng, weekday_kor, type }
        
        
        
        
        init(from decoder: Decoder) throws {
            let rootContainer   = try decoder.container(keyedBy: CodingKeys.self)
            
            do {
                listCount = try rootContainer.decode(Int.self, forKey: .count)
            }
            catch{
                listCount = nil
            }
            try time = rootContainer.decode(String.self, forKey: .time)
            
            do {
                data = try rootContainer.decode([TimeLineItemModel].self, forKey: .data)
            }
            catch {
                month = try rootContainer.decode(Int.self, forKey: .month)
                day = try rootContainer.decode(Int.self, forKey: .day)
                weekday_eng = try rootContainer.decode(String.self, forKey: .weekday_eng)
                weekday_kor = try rootContainer.decode(String.self, forKey: .weekday_kor)
                type = try rootContainer.decode(String.self, forKey: .type)
            }
            
    
//            do {
//               
//            }
//            catch(let error){
//                print("parse error",error)
//            }
            
            
            
            
            
            
            
            
        }
    }
    
    
    struct TimeLineItemModel : Decodable {
        
        var type : String
        var id :Int
        var name : String
        var url : String
        var shop : String
        var start_datetime : String
        var end_datetime : String
        var price : Int
        var original_price : Int
        var sametime : [SameTimeItemModel]
        var image_list : [String]
        
        
        
        enum CodingKeys : CodingKey { case type , id , name, url , start_datetime, end_datetime, price ,original_price, sametime , image_list , shop }
        
        init(from decoder: Decoder) throws {
            let rootContainer   = try decoder.container(keyedBy: CodingKeys.self)
            
            try type = rootContainer.decode(String.self, forKey: .type)
            try id = rootContainer.decode(Int.self, forKey: .id)
            try name = rootContainer.decode(String.self, forKey: .name)
            try url = rootContainer.decode(String.self, forKey: .url)
            try shop = rootContainer.decode(String.self, forKey: .shop)
            if let starttime = try? rootContainer.decode(String.self, forKey: .start_datetime) {
                self.start_datetime = starttime
            }
            else if let starttime = try? rootContainer.decode(Int.self, forKey: .start_datetime) {
                self.start_datetime = String(starttime)
            }
            else {
                self.start_datetime = ""
            }
            
            if let endtime = try? rootContainer.decode(String.self, forKey: .end_datetime) {
                self.end_datetime = endtime
            }
            else {
                self.end_datetime = ""
            }
            try price = rootContainer.decode(Int.self, forKey: .price)
            
            if let originPrice = try? rootContainer.decode(Int.self, forKey: .original_price) {
                self.original_price = originPrice
            }
            else {
                self.original_price = 0
            }
            if let sameTimeList = try? rootContainer.decode([SameTimeItemModel].self, forKey: .sametime) {
                self.sametime = sameTimeList
            }
            else {
                self.sametime = []
                
            }
            if let imageList = try?  rootContainer.decode([String].self, forKey: .image_list) {
                self.image_list = imageList
            }
            else {
                self.image_list = []
            }
            
        }
        
        
    }
    
    struct SameTimeItemModel : Decodable {
        var id : Int
        var name : String
        var image : String
        var low_price : Int
    }
    
    
}

