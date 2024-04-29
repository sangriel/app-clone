//
//  LiveItemCollectionviewCell.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/28.
//

import Foundation
import UIKit

/**
 * 생방송 테이블 셀 안의 생방송 아이템 셀
 */
class LiveItemCollectionViewCell : UICollectionViewCell {
    
    static let cellid = "liveitemcollectionviewcellid"
    
    private let playerImageView = UIImageView()
    
    private let companyLogoImageView = UIImageView()
    
    private let companyNameLabel = UILabel()
    
    lazy private var companyStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [companyLogoImageView,companyNameLabel])
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()
    
    private let itemNameLabel = UILabel()
    
    private let priceLabel = UILabel()
    
    
    lazy private var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [playerImageView,
                                                   companyStack,
                                                   itemNameLabel,
                                                   priceLabel
                                                  ])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makestack()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configurecell(viewmodel : LiveItemCollectionViewCellViewModel){
        ImageDownLoader.shared.download(imageUrl: viewmodel.imag_list[0]) { data , error in
            if let error = error {
                print("error",error)
                //오류 표시 이미지가 있다면 오류 표시 이미지를 삽입
                return
            }
            if let data = data {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.playerImageView.image = UIImage(data: data)
                }
            }
        }
        
        
        self.companyNameLabel.text = viewmodel.shop
        self.itemNameLabel.text = viewmodel.name
        self.priceLabel.attributedText = viewmodel.price
        
    }
    
    
}
extension LiveItemCollectionViewCell {
    private func makestack(){
        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        stack.heightAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true
        
        
        
        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        playerImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        playerImageView.contentMode = .scaleAspectFill
        playerImageView.clipsToBounds = true
        
        companyStack.translatesAutoresizingMaskIntoConstraints = false
        companyStack.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        
        let imageSize = UIImage(named: "buzznilogo")!.size
        companyLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        companyLogoImageView.widthAnchor.constraint(equalToConstant: 12 * (imageSize.width / imageSize.height)).isActive = true
        companyLogoImageView.image = UIImage(named: "buzznilogo")
        companyLogoImageView.contentMode = .scaleAspectFit
        
        
        
        
        companyNameLabel.textColor = .rgb(red: 51, green: 51, blue: 51, alpha: 1)
        companyNameLabel.font = UIFont.systemFont(ofSize: 9, weight: .regular)
        companyNameLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        
        itemNameLabel.textColor = .rgb(red: 51, green: 51, blue: 51, alpha: 51)
        itemNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        itemNameLabel.numberOfLines = 2
        itemNameLabel.lineBreakMode = .byWordWrapping
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        itemNameLabel.setContentHuggingPriority(UILayoutPriority(500), for: .vertical)
        itemNameLabel.lineBreakMode = .byTruncatingTail
        
        priceLabel.textColor = .rgb(red: 51, green: 51, blue: 51, alpha: 1)
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        priceLabel.setContentHuggingPriority(UILayoutPriority(750), for: .vertical)
        
    }
}
