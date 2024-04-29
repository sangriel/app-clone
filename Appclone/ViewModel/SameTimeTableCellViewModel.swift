//
//  SameTimeTableCellViewModel.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/29.
//

import Foundation
import UIKit



struct SameTimeTableCellViewModel {
    var parentId : Int
    var id : Int
    var name : String
    var image : String
    var low_price : NSAttributedString
    
    
    init(parentId : Int, id : Int, name : String, image : String, low_price : Int){
        self.parentId = parentId
        self.id = id
        self.name = name
        self.image = image
        
        let low_priceStr = low_price.toMoneyForm()
        
        let attr = NSMutableAttributedString(string: low_priceStr,attributes: [.font : UIFont.systemFont(ofSize: 13, weight: .regular),
                                                                                .foregroundColor : UIColor.rgb(red: 51, green: 51, blue: 51, alpha: 1)])
        let range = NSString(string: low_priceStr).range(of: "원")
        attr.addAttributes([.font : UIFont.systemFont(ofSize: 11, weight: .regular)], range: range)
        
        self.low_price = attr
        
        
        
        
    }
    
}
