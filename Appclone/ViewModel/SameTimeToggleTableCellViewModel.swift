//
//  SameTimeToggleTableCellViewModel.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/29.
//

import Foundation
import UIKit


struct SameTimeToggleTableCellViewModel {
    
    
    
    var title : NSAttributedString
    var isSelected : Bool
    var id : Int
    
    init(numberOfSameTime : Int, isSelected : Bool,id : Int){
        self.isSelected = isSelected
        self.id = id 
        let btnTitleAttr = NSMutableAttributedString(string: "함께 방송하는 상품 \(numberOfSameTime)개", attributes: [
            .font : UIFont.systemFont(ofSize: 10, weight: .regular),
            .foregroundColor : UIColor.rgb(red: 153, green: 153, blue: 153, alpha: 1)])
        let range = NSString(string: "함께 방송하는 상품 \(numberOfSameTime)개").range(of: "\(numberOfSameTime)")
        btnTitleAttr.addAttributes([.font : UIFont.systemFont(ofSize: 12, weight: .regular),
                                    .foregroundColor : UIColor.rgb(red: 51, green: 51, blue: 51, alpha: 1) ],
                                   range: range)
        self.title = btnTitleAttr
        
    }
    
    
}
