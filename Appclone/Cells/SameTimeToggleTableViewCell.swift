//
//  SameTimeToggleTableViewCell.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/29.
//

import Foundation
import UIKit

/**
 * 동시간대 상품 더보기 버튼 셀 
 */
class SameTimeToggleTableViewCell : UITableViewCell {
    
    
    static let cellid = "sametimetoggletableviewcellid"
    
    private let lineView = UIView()
    
    let label = UILabel()
    
    let arrowImage = UIImageView()
    
    lazy private var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label,arrowImage])
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()
    
    override var isSelected: Bool {
        didSet(newVal){
            arrowImage.transform = isSelected ? .init(rotationAngle: .pi) : .init(rotationAngle: 0)
        }
    }
    
    private let seperator = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makelineView()
        makestack()
        makeseperator()
        self.selectionStyle = .none
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(viewmodel : SameTimeToggleTableCellViewModel){
        self.isSelected = viewmodel.isSelected
        self.label.attributedText = viewmodel.title
    }
    
    
    
    
    
    
}
extension SameTimeToggleTableViewCell {
    private func makelineView(){
        self.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.backgroundColor = .rgb(red: 245, green: 245, blue: 245, alpha: 1)
    }
    private func makestack(){
        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 15).isActive = true
        stack.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        arrowImage.image = UIImage(named: "arrowDown")?.withRenderingMode(.alwaysTemplate)
        arrowImage.tintColor = .rgb(red: 153, green: 153, blue: 153, alpha: 1)
        arrowImage.contentMode = .scaleAspectFit
    }
    private func makeseperator(){
        contentView.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        seperator.backgroundColor = .rgb(red: 245, green: 245, blue: 245, alpha: 1)
    }
    
}
