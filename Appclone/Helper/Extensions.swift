//
//  Extensions.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/27.
//

import Foundation
import UIKit





extension Date {
    func getLocalTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmm"
        let dateString = df.string(from: self)
        return dateString
    }
    
    
    
    
    
}

extension UIColor {
    static func rgb(red : CGFloat, green : CGFloat, blue : CGFloat, alpha : CGFloat ) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}



extension Int {
    func toMoneyForm() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let result = formatter.string(from: self as NSNumber) {
            return result + "원"
        }
        else {
            return String(self) + "원"
        }
        
    }
    
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}


extension UITableView {
    func reloadDataAndKeepOffset(listData : [[Any]]) {
        
        
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.performBatchUpdates {
            let addedSection = listData.count - self.numberOfSections
            var addingIndexPathSet : [IndexPath] = []
            for section in 0..<addedSection {
                addingIndexPathSet.append(contentsOf: (0..<listData[section].count).compactMap({ i -> IndexPath in
                    return IndexPath(row: i, section: section)
                }))
            }
    
            self.insertSections( (0..<addedSection).map{ $0 }, animationStyle: .automatic)
            self.insertRows(at: addingIndexPathSet, with: .automatic)
    
        } completion: { finished in
            CATransaction.commit()
        }
    }
}
