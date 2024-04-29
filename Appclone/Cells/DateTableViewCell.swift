//
//  DateTableViewCell.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/29.
//

import Foundation
import UIKit


/**
 * 테이블 뷰 날짜 셀 
 */
class DateTableViewCell : UITableViewCell {
    
    static let cellid = "datetableviewcellid"
    
    private let calendarImage = UIImageView()
    
    
    private let leftlineView = UIView()
    private let rightlineView = UIView()
    
    private let monthAndDateLabel = UILabel()
    
    private let weekDayLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        makemonthAndDateLabel()
        makecalendarImage()
        makeweekDayLabel()
        makeleflineView()
        makerighlineView()
        
        contentView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func configureCell(viewmodel : NotLiveSectionTableCellViewModel){
        
        self.monthAndDateLabel.text = "\(viewmodel.month!)월 \(viewmodel.day!)일"
        self.weekDayLabel.text = "\(viewmodel.weekday_kor!)"
        
        
    }
    
    
    
    
    
}
extension DateTableViewCell {
    
    private func makemonthAndDateLabel(){
        contentView.addSubview(monthAndDateLabel)
        monthAndDateLabel.translatesAutoresizingMaskIntoConstraints = false
        monthAndDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        monthAndDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        monthAndDateLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        monthAndDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        monthAndDateLabel.textColor = .rgb(red: 153, green: 153, blue: 153, alpha: 1)
        monthAndDateLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        monthAndDateLabel.textAlignment = .center
        monthAndDateLabel.backgroundColor = .white
        
    }
    private func makecalendarImage(){
        contentView.addSubview(calendarImage)
        calendarImage.translatesAutoresizingMaskIntoConstraints = false
        calendarImage.bottomAnchor.constraint(equalTo: monthAndDateLabel.topAnchor, constant: -10).isActive = true
        calendarImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        calendarImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        calendarImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        calendarImage.image = UIImage(named: "calendarIcon")?.withRenderingMode(.alwaysTemplate)
        calendarImage.tintColor = .rgb(red: 153, green: 153, blue: 153, alpha: 1)
    }
    private func makeweekDayLabel(){
        contentView.addSubview(weekDayLabel)
        weekDayLabel.translatesAutoresizingMaskIntoConstraints = false
        weekDayLabel.topAnchor.constraint(equalTo: monthAndDateLabel.bottomAnchor, constant: 10).isActive = true
        weekDayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        weekDayLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        weekDayLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        weekDayLabel.textColor = .rgb(red: 153, green: 153, blue: 153, alpha: 1)
        weekDayLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        weekDayLabel.textAlignment = .center
    }
    
    private func makeleflineView(){
        contentView.addSubview(leftlineView)
        leftlineView.translatesAutoresizingMaskIntoConstraints = false
        leftlineView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        leftlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        leftlineView.trailingAnchor.constraint(equalTo: monthAndDateLabel.leadingAnchor, constant: -10).isActive = true
        leftlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        leftlineView.backgroundColor = .rgb(red: 153, green: 153, blue: 153, alpha: 1)
    }
    private func makerighlineView(){
        contentView.addSubview(rightlineView)
        rightlineView.translatesAutoresizingMaskIntoConstraints = false
        rightlineView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        rightlineView.leadingAnchor.constraint(equalTo: monthAndDateLabel.trailingAnchor, constant: 10).isActive = true
        rightlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        rightlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        rightlineView.backgroundColor = .rgb(red: 153, green: 153, blue: 153, alpha: 1)
    }
    
    
}
