//
//  SameTimeTableViewCell.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/29.
//

import Foundation
import UIKit

/**
 * 동시간대 상품  셀
 */
class SameTimeTableViewCell : UITableViewCell {
    
    static let cellid = "sametimetableviewcellid"
    
    private let lineView = UIView()
    
    let itemimageView = UIImageView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    
    lazy private var infoStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel,priceLabel])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        makelineView()
        makeimageView()
        makeinfoStack()
        
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(viewmodel : SameTimeTableCellViewModel){
        ImageDownLoader.shared.download(imageUrl: viewmodel.image) {  data, error in
            if let error = error {
                print(error)
            }
            if let data = data {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.itemimageView.image = UIImage(data: data)
                    
                }

            }
        }
        
        
        self.nameLabel.text = viewmodel.name
        self.priceLabel.attributedText = viewmodel.low_price
        
    }
    
    
    
}
extension SameTimeTableViewCell {
    private func makelineView(){
        self.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.backgroundColor = .rgb(red: 245, green: 245, blue: 245, alpha: 1)
    }
    private func makeimageView(){
        self.addSubview(itemimageView)
        itemimageView.translatesAutoresizingMaskIntoConstraints = false
        itemimageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        itemimageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        itemimageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        itemimageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        itemimageView.contentMode = .scaleAspectFill
        itemimageView.clipsToBounds = true
    }
    private func makeinfoStack(){
        self.addSubview(infoStack)
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        infoStack.leadingAnchor.constraint(equalTo: itemimageView.trailingAnchor, constant: 10).isActive = true
        infoStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        infoStack.heightAnchor.constraint(lessThanOrEqualToConstant: 40).isActive = true
        
        
        nameLabel.textColor = .rgb(red: 51, green: 51, blue: 51, alpha: 1)
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
    }
}
