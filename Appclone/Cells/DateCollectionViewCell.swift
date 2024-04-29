//
//  DateCollectionViewCell.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/27.
//

import Foundation
import UIKit


/**
 * 화면 상단의 날짜 셀 
 */
class DateCollectionViewCell : UICollectionViewCell {

    
    static let cellid = "collectionviewdatecellid"
    
    
    private let circleView = UIView()
    
    private let dateLabel = UILabel()
    
    private let dayLabel = UILabel()
    
    lazy private var labelStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dateLabel,dayLabel])
        stack.axis = .vertical
        return stack
    }()
    
    private let isTodayUnderBar = UIView()
    
    
    override init(frame : CGRect){
        super.init(frame: frame)
        self.backgroundColor = .clear
        makecircleView()
        makelabelStack()
        makeisTodayUnderBar()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.circleView.layer.cornerRadius = self.circleView.frame.height / 2
            
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func configureCell(viewmodel : DateCollectionViewCellViewModel){
        
        self.dateLabel.text = viewmodel.date
        self.dayLabel.text = viewmodel.day
        
        self.circleView.isHidden = !viewmodel.isSelected
        
        self.isTodayUnderBar.isHidden = !(viewmodel.isSelected == false && viewmodel.isToday)
        
        if viewmodel.isSelected {
            self.dateLabel.textColor = .white
            self.dayLabel.textColor = .white
        }
        else if viewmodel.isToday {
            self.dateLabel.textColor = .rgb(red: 244, green: 88, blue: 99, alpha: 1)
            self.dayLabel.textColor = .rgb(red: 244, green: 88, blue: 99, alpha: 1)
        }
        else {
            self.dateLabel.textColor = .rgb(red: 108, green: 108, blue: 108, alpha: 1)
            self.dayLabel.textColor = .rgb(red: 108, green: 108, blue: 108, alpha: 1)
        }
    }
    
    
    
    
}
extension DateCollectionViewCell {
    private func makecircleView(){
        self.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        circleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3).isActive = true
        circleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3).isActive = true
        circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        circleView.backgroundColor = .rgb(red: 244, green: 88, blue: 99, alpha: 1)
    }
    private func makelabelStack(){
        self.addSubview(labelStack)
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        labelStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        labelStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        labelStack.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        dateLabel.textAlignment = .center
        
        
        dayLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        dayLabel.textAlignment = .center
        
    }
    private func makeisTodayUnderBar(){
        self.addSubview(isTodayUnderBar)
        isTodayUnderBar.translatesAutoresizingMaskIntoConstraints = false
        isTodayUnderBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        isTodayUnderBar.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        isTodayUnderBar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        isTodayUnderBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        isTodayUnderBar.backgroundColor = .rgb(red: 244, green: 88, blue: 99, alpha: 1)
    }
    
    
    
    
}
