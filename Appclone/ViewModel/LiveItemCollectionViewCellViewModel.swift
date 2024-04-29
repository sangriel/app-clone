//
//  LiveItemCollectionViewCellViewModel.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/28.
//

import Foundation
import UIKit

struct LiveItemCollectionViewCellViewModel {
    
    
    var id : Int
    var imag_list : [String]
    var shop : String
    var name : String
    var url : String
    var price : NSAttributedString
    
    init(id : Int,imag_list : [String],shop : String,name : String,url : String,  price : String){
        self.id = id
        self.imag_list = imag_list
        self.shop = shop
        self.name = name
        self.url = url
        
        let attr = NSMutableAttributedString(string: price,attributes: [.font : UIFont.systemFont(ofSize: 15, weight: .bold),
                                                                                .foregroundColor : UIColor.rgb(red: 51, green: 51, blue: 51, alpha: 1)])
        let range = NSString(string: price).range(of: "원")
        attr.addAttributes([.font : UIFont.systemFont(ofSize: 12, weight: .bold)], range: range)
        
        self.price = attr
    
    }
    
    
}
