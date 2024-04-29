//
//  TimeSectionHeaderView.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/29.
//

import Foundation
import UIKit


/**
 *  현재 섹션의 시간을 알려주는 테이블 헤더뷰
 */
class TimeSectionHeaderView : UITableViewHeaderFooterView{
    
    
    let textView = UITextView()
    
    static let headerViewId = "timesectionHeaderViewId"
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .init(white: 0, alpha: 0)
        self.layer.backgroundColor = UIColor.clear.cgColor
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        contentView.backgroundColor = .init(white: 0, alpha: 0)
        
        maketextView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.textView.layer.cornerRadius = self.textView.frame.height / 2
            
        }
    }
    
    
    
    
}
extension TimeSectionHeaderView {
    private func maketextView(){
        self.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        textView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 20, bottom: 3, right: 20)
        textView.textContainer.maximumNumberOfLines = 1
        textView.textContainer.lineFragmentPadding = 0
    }
    
    
}
