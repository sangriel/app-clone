//
//  NotLiveSectionTableViewCell.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/28.
//

import Foundation
import UIKit
import RxSwift

/**
 * 비 생방송 아이템 셀
 */
class NotLiveSectionTableViewCell : UITableViewCell {
    
    static let cellid = "notlivesectiontableviewcellid"
    
    
    private let itemImageView = UIImageView()
    
    private let companyImage = UIImageView()
    
    private let timeLabel = UILabel()
    
    lazy private var companyStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [companyImage,timeLabel])
        stack.axis = .horizontal
        stack.spacing = 2
        
        return stack
    }()
    
    private let itemNameLabel = UILabel()
    
    private let originPriceLabel = UILabel()
    
    private let priceLabel = UILabel()
    
    lazy private var mainItemInfoStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [companyStack,itemNameLabel,originPriceLabel,priceLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        return stack
    }()
    
    
    private let imageBottomInfoLabel = UILabel()
    
    
    private let seperator = UIView()
    
    
    var disposebag = DisposeBag()
    
    lazy private var contentViewBottomToSeperatorAnc : NSLayoutConstraint = {
        return contentView.bottomAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 0)
    }()
    
    lazy private var contentViewBottomToImageBottomLabel : NSLayoutConstraint = {
        return contentView.bottomAnchor.constraint(equalTo: imageBottomInfoLabel.bottomAnchor, constant: 10)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        makeitemImageView()
        makemainItemInfoStack()
        makeimageBottomInfoLabel()
        makeseperator()
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(viewmodel : NotLiveSectionTableCellViewModel){
        
        
        if let image = viewmodel.image_list.first {
            ImageDownLoader.shared.download(imageUrl: image) { data, error  in
                if let error = error {
                    print(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.itemImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        
        self.timeLabel.text = viewmodel.liveTime
        
        self.itemNameLabel.text = viewmodel.name
        
        if let origin_price = viewmodel.origin_price {
            self.originPriceLabel.isHidden = false
            self.originPriceLabel.attributedText = origin_price
        }
        else {
            self.originPriceLabel.isHidden = true
        }
        
        self.priceLabel.attributedText = viewmodel.price
        
        contentViewBottomToSeperatorAnc.isActive = !viewmodel.haveSameTime
        contentViewBottomToImageBottomLabel.isActive = viewmodel.haveSameTime
        seperator.isHidden = viewmodel.haveSameTime
            
        
        
        
        
    }
    
    
    
}
extension NotLiveSectionTableViewCell {
    private func makeitemImageView(){
        contentView.addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
    }
    private func makemainItemInfoStack(){
        contentView.addSubview(mainItemInfoStack)
        mainItemInfoStack.translatesAutoresizingMaskIntoConstraints = false
        mainItemInfoStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        mainItemInfoStack.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10).isActive = true
        mainItemInfoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        mainItemInfoStack.bottomAnchor.constraint(lessThanOrEqualTo: itemImageView.bottomAnchor).isActive = true
        
        
        companyStack.translatesAutoresizingMaskIntoConstraints = false
        companyStack.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        let imageSize = UIImage(named: "buzznilogo")!.size
        companyImage.translatesAutoresizingMaskIntoConstraints = false
        companyImage.widthAnchor.constraint(equalToConstant: 12 * (imageSize.width / imageSize.height)).isActive = true
        companyImage.image = UIImage(named: "buzznilogo")
        companyImage.contentMode = .scaleAspectFit
        
        timeLabel.textColor = .rgb(red: 153, green: 153, blue: 153, alpha: 1)
        timeLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        
        itemNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        itemNameLabel.textColor = .rgb(red: 51, green: 51, blue: 51, alpha: 1)
        itemNameLabel.numberOfLines = 2
        itemNameLabel.lineBreakMode = .byTruncatingTail
        
        
    }
    
    private func makeimageBottomInfoLabel(){
        contentView.addSubview(imageBottomInfoLabel)
        imageBottomInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        imageBottomInfoLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10).isActive = true
        imageBottomInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        imageBottomInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        imageBottomInfoLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageBottomInfoLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        imageBottomInfoLabel.textColor = .rgb(red: 153, green: 153, blue: 153, alpha: 1)
        
        imageBottomInfoLabel.text = "무료배송 ㆍ 627명 관심"
    }
    
    private func makeseperator(){
        contentView.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.topAnchor.constraint(equalTo: imageBottomInfoLabel.bottomAnchor, constant: 10).isActive = true
        seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        seperator.backgroundColor = .rgb(red: 245, green: 245, blue: 245, alpha: 1)
    }
}
