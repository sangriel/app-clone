//
//  NotLiveSectionTableCellViewModel.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/28.
//

import Foundation
import UIKit


struct NotLiveSectionTableCellViewModel {
    
    
    var id : Int
    var name : String
    var url : String
    var shop : String
    var start_datetime : String
    var end_datetime : String
    var liveTime : String = ""
    var origin_price : NSAttributedString?
    var price : NSAttributedString
    var image_list : [String]
    var time : String
    var month : Int?
    var day : Int?
    var weekday_kor : String?
    var type : String?
    var isExpanded = false
    var haveSameTime : Bool
    
    init(id : Int, name : String,url : String, shop : String, start_datetime : String, end_datetime : String, originPrice : Int, price : Int, image_list : [String], time : String,month : Int?,day : Int?,weekday_kor : String?,type : String?,haveSameTime : Bool ){
        self.id = id
        self.name = name
        self.url = url
        self.shop = shop
        self.start_datetime = start_datetime
        self.end_datetime = end_datetime
        self.image_list = image_list
        self.time = time
        self.month = month
        self.day = day
        self.weekday_kor = weekday_kor
        self.type = type
        self.haveSameTime = haveSameTime
        
        if originPrice == 0 {
            origin_price = nil
        }
        else {
            let origin_priceStr = originPrice.toMoneyForm()
            
            let originAttr = NSMutableAttributedString(string: origin_priceStr,attributes:[
                .font : UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor : UIColor.rgb(red: 153, green: 153, blue: 153, alpha: 1),
                .strikethroughStyle : NSUnderlineStyle.single.rawValue,
                .strikethroughColor : UIColor.rgb(red: 153, green: 153, blue: 153, alpha: 1).cgColor])
            
            self.origin_price = originAttr
        }
        
        
        if price == 0 {
            let priceAttr = NSAttributedString(string: "상담/렌탈", attributes: [
                .font : UIFont.systemFont(ofSize: 15, weight: .bold),
                .foregroundColor : UIColor.rgb(red: 153, green: 153, blue: 153, alpha: 1)])
            self.price = priceAttr
        }
        else {
            let priceStr = price.toMoneyForm()
            
            let priceAttr = NSMutableAttributedString(string: priceStr,attributes: [
                .font : UIFont.systemFont(ofSize: 15, weight: .bold),
                .foregroundColor : UIColor.rgb(red: 51, green: 51, blue: 51, alpha: 1)])
            
            let range = NSString(string: priceStr).range(of: "원")
            priceAttr.addAttributes([ .font : UIFont.systemFont(ofSize: 13, weight: .bold)], range: range)
            self.price = priceAttr
            
        }
        
        
        var startTime = ""
        var endTime = ""
        if start_datetime.count >= 12 {
            startTime = "\(String(Array(start_datetime)[8...9])):\(String(Array(start_datetime)[10...11]))"
        }
        if end_datetime.count >= 12 {
            endTime = "\(String(Array(end_datetime)[8...9])):\(String(Array(end_datetime)[10...11]))"
        }
        self.liveTime = startTime + " ~ " + endTime
        
        
        
        
    
    }
    
    
    
    
    
    
}
