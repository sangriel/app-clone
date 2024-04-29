//
//  LiveSectionTableViewCell.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/28.
//

import Foundation
import UIKit

/**
 * 생방송 시간대 테이블 뷰 셀 
 */
class LiveSectionTableViewCell : UITableViewCell {
    
    
    static let cellid = "livesectiontableviewcellid"
    
    private var liveItemViewModel : [LiveItemCollectionViewCellViewModel] = []
    
    private let seperator = UIView()
    
    let itemHeight : CGFloat = 180

    lazy private var liveItemCv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
//        layout.estimatedItemSize = CGSize(width: (UIScreen.main.bounds.width / 2) / 2, height: 200)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LiveItemCollectionViewCell.self, forCellWithReuseIdentifier: LiveItemCollectionViewCell.cellid)
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        makeliveItemCv()
        makeseperator()
        self.selectionStyle = .none
        
//        contentView.bottomAnchor.constraint(equalTo: liveItemCv.bottomAnchor, constant: 0).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func configureCell(viewModel : LiveSectionTableViewCellViewModel){
        self.liveItemViewModel = viewModel.liveItemViewModel

        let heightMultiplier = ceil(CGFloat(viewModel.count) / 2)
        
        self.liveItemCv.heightAnchor.constraint(equalToConstant: CGFloat(heightMultiplier * itemHeight + ( (heightMultiplier - 1) * 10) + 10  )).isActive = true
        self.contentView.heightAnchor.constraint(equalToConstant: CGFloat(heightMultiplier * itemHeight + ( (heightMultiplier - 1) * 10) + 10 + 10 + 10 )).isActive = true
        

        
        self.liveItemCv.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
}
extension LiveSectionTableViewCell {
    private func makeliveItemCv(){
        contentView.addSubview(liveItemCv)
        liveItemCv.translatesAutoresizingMaskIntoConstraints = false
        liveItemCv.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        liveItemCv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        liveItemCv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        liveItemCv.backgroundColor = .white
    }
    private func makeseperator(){
        contentView.addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.topAnchor.constraint(equalTo: liveItemCv.bottomAnchor, constant: 0).isActive = true
        seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        seperator.backgroundColor = .rgb(red: 245, green: 245, blue: 245, alpha: 1)
    }
    
    
}
extension LiveSectionTableViewCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveItemViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveItemCollectionViewCell.cellid, for: indexPath) as! LiveItemCollectionViewCell
        cell.configurecell(viewmodel: liveItemViewModel[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 15, height: itemHeight)
    }
    
    
    
    
}
