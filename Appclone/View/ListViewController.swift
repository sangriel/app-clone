//
//  VideoViewListController.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class ListViewController: UIViewController {
    
    lazy private var dateCv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.cellid)
        
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    lazy private var itemTb : UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.backgroundColor = .clear
        tb.separatorStyle = .none
        tb.estimatedRowHeight = 200
        tb.rowHeight = UITableView.automaticDimension
        tb.delegate = self
        tb.dataSource = self
        tb.register(LiveSectionTableViewCell.self, forCellReuseIdentifier: LiveSectionTableViewCell.cellid)
        tb.register(NotLiveSectionTableViewCell.self, forCellReuseIdentifier: NotLiveSectionTableViewCell.cellid)
        tb.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.cellid)
        tb.register(SameTimeTableViewCell.self, forCellReuseIdentifier: SameTimeTableViewCell.cellid)
        tb.register(SameTimeToggleTableViewCell.self, forCellReuseIdentifier: SameTimeToggleTableViewCell.cellid)
        tb.register(TimeSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: TimeSectionHeaderView.headerViewId)
        
        return tb
    }()
    
    
    private let viewmodel = ListViewModel(timeLineService: TimeLineService())
    
    private var disposebag = DisposeBag()
    
    //처음 진입시 오늘 날짜가 중앙에 위치하도록 조절하는 변수
    private var setInitialState : Bool = true
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        makedateCv()
        makeitemTb()
        
        
        //그림자를 가리지 않기 위해 날짜 컬렉션뷰를 맨 상단으로 불러드림
        self.view.bringSubviewToFront(dateCv)
        
        
        binddateCv()
        binditemTb()
        
        viewmodel.configureDateViewModels()
        
        viewmodel.fetchItem.onNext(.center)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //dateCv shadow layer
        dateCv.layer.shadowColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        dateCv.layer.shadowOpacity = 1
        dateCv.layer.shadowRadius = 5
        dateCv.layer.shadowOffset = CGSize(width: 0, height: 5)
        dateCv.layer.shadowPath = nil
        
        
        
        if dateCv.numberOfItems(inSection: 0) != 0 && setInitialState {
            dateCv.scrollToItem(at: IndexPath(item: 4, section: 0), at: .centeredHorizontally, animated: false)
            setInitialState = false
        }
        
    }
    
    
    //MARK: - 날짜 컬레션 뷰 바인딩
    private func binddateCv(){
        
        
        viewmodel.dateViewModels
            .bind(to: dateCv.rx.items(cellIdentifier: DateCollectionViewCell.cellid , cellType: DateCollectionViewCell.self)){
                (index, viewmodel, cell) in
                cell.configureCell(viewmodel: viewmodel)
            }
            .disposed(by: disposebag)
        
        
        
        
        viewmodel.centerDateIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext : { [unowned self] index in
                self.dateCv.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            })
            .disposed(by: disposebag)
        
        self.dateCv.rx.itemSelected
            .map{ $0.item }
            .bind(to: viewmodel.dateSelected)
            .disposed(by: disposebag)
        
        
        
    }
    
    //MARK: - 아이템 테이블뷰 바인딩
    private func binditemTb(){
        
        viewmodel.reloadTableView
            .subscribe(onNext : { [unowned self] direction in
                if direction == .up {
                    //새로운 데이터가 위에 쌓이는 경우 현재 contentOffset을 저장하여 리로딩 후 같은 아이템을 계속 보여주게 한다
                    //reloadDataAndKeepOffset은 범용적으로 사용하기 위해서 데이터를 인자로 받게 하였다.
                    itemTb.reloadDataAndKeepOffset(listData: viewmodel.listData)
                }
                else {
                    itemTb.reloadData()
                }
                
                viewmodel.tableReloadFinished.onNext(())
            })
            .disposed(by: disposebag)
        
        viewmodel.reloadRowAtTableView
            .subscribe(onNext : { [unowned self] indexPath in
                itemTb.reloadRows(at: [indexPath], with: .automatic)
            })
            .disposed(by: disposebag)
        
        viewmodel.insertOrDeleteTableView
            .subscribe(onNext : { [unowned self] indexPathSet,updateType in
                if updateType == .insert {
                    itemTb.beginUpdates()
                    itemTb.insertRows(at: indexPathSet, with: .automatic)
                    itemTb.endUpdates()
                }
                else {
                    itemTb.beginUpdates()
                    itemTb.deleteRows(at: indexPathSet, with: .automatic)
                    itemTb.endUpdates()
                }
            })
            .disposed(by: disposebag)
        
        viewmodel.scrollTableViewToIndex
            .subscribe(onNext : { [unowned self] indexPath,animated in
            
                itemTb.scrollToRow(at: indexPath, at: .top, animated: animated)
            })
            .disposed(by: disposebag)
        
        
    }
    
    
    
    
}
//MARK: - layout setup methods
extension ListViewController {
    private func makedateCv(){
        self.view.addSubview(dateCv)
        dateCv.translatesAutoresizingMaskIntoConstraints = false
        dateCv.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        dateCv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        dateCv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        dateCv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dateCv.backgroundColor = .white
        dateCv.clipsToBounds = false
        
    }
    private func makeitemTb(){
        self.view.addSubview(itemTb)
        itemTb.translatesAutoresizingMaskIntoConstraints = false
        itemTb.topAnchor.constraint(equalTo: dateCv.bottomAnchor, constant: 0).isActive = true
        itemTb.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        itemTb.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        itemTb.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        itemTb.backgroundColor = .white
        itemTb.isOpaque = false
        itemTb.backgroundView = nil
        
    }
}

//MARK: - 상단 날짜 컬렉션 뷰
extension ListViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
//MARK: - 쇼핑몰 아이템 테이블 뷰
extension ListViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TimeSectionHeaderView.headerViewId) as! TimeSectionHeaderView
       
        if let live = viewmodel.listData[section] as? [LiveSectionTableViewCellViewModel], let _ = live.first {
            header.textView.text = "생방송"
            header.textView.backgroundColor = .rgb(red: 244, green: 88, blue: 99, alpha: 1)
        }
        else if let first = viewmodel.listData[section].first,
                let notLive = first as? NotLiveSectionTableCellViewModel {
            if let type = notLive.type, type == "date_info" {
                
                return nil
            }
            else {
                let currentSectionTime = notLive.time.prefix(10)
                let currentTime = Date().getLocalTime().prefix(10)
                if Int(currentSectionTime) ?? 0 < Int(currentTime) ?? 0 { //현재 시간보다 빠르면 회색
                    header.textView.backgroundColor = .lightGray
                }
                else { //현재 시간보다 느리면 파란색
                    header.textView.backgroundColor = .rgb(red: 11, green: 33, blue: 74, alpha: 1)
                }
                
                let time = Int(String(Array(currentSectionTime)[8...9])) ?? 0
                
                if time > 12 {
                    header.textView.text = "오후 \(time - 12)시"
                }
                else if time == 12 {
                    header.textView.text = "오후 \(12)시"
                }
                else if time == 0 {
                    header.textView.text = "오전 \(12)시"
                }
                else {
                    header.textView.text = "오전 \(time)시"
                }
            }
            
        }
       
        header.backgroundView = nil
        header.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            header.backgroundConfiguration = .clear()
        } else {
            // Fallback on earlier versions
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let first = viewmodel.listData[section].first,
           let notLive = first as? NotLiveSectionTableCellViewModel,
           let type = notLive.type,
           type == "date_info" {
            return 0
        }
        else {
            return 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewmodel.tableViewWillDisplayIndexPath.onNext(indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewmodel.listData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.listData[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = viewmodel.listData[indexPath.section]
        if let dateInfoData = sectionData[indexPath.row] as? NotLiveSectionTableCellViewModel,
                let type = dateInfoData.type, type == "date_info" {
            let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.cellid, for: indexPath) as! DateTableViewCell
            cell.configureCell(viewmodel: dateInfoData)
            return cell
        }
        else if let notLiveData = sectionData[indexPath.row] as? NotLiveSectionTableCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: NotLiveSectionTableViewCell.cellid, for: indexPath) as! NotLiveSectionTableViewCell
            cell.configureCell(viewmodel: notLiveData)
            return cell
        }
        else if let sameTimeData = sectionData[indexPath.row] as? SameTimeTableCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: SameTimeTableViewCell.cellid, for: indexPath) as! SameTimeTableViewCell
            cell.configureCell(viewmodel: sameTimeData)
            return cell
        }
        else if let sameTimeToggleData = sectionData[indexPath.row] as? SameTimeToggleTableCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: SameTimeToggleTableViewCell.cellid, for: indexPath) as! SameTimeToggleTableViewCell
            cell.configureCell(viewmodel: sameTimeToggleData)
            return cell
        }
        else if let liveDatas = sectionData[indexPath.row] as? LiveSectionTableViewCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: LiveSectionTableViewCell.cellid, for: indexPath) as! LiveSectionTableViewCell
            cell.configureCell(viewModel: liveDatas)
            return cell
        }
        else {
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? SameTimeToggleTableViewCell {
            viewmodel.insertOrDeleteSameTime.onNext(indexPath)
        }
    }
}
extension ListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == itemTb {
            let position = scrollView.contentOffset.y
            
            //아래로 스크롤링 할때
            //상수로 한다면 콘텐츠 사이즈 대비 너무 작기 때문에 한계선을 비율로써 정해줌
            let downLimitOffset = 100 * (itemTb.contentSize.height / scrollView.frame.size.height)
            let upLimitOffset = 100.0 * (itemTb.contentSize.height / scrollView.frame.size.height)
            
            if position > itemTb.contentSize.height - scrollView.frame.size.height - downLimitOffset
                && viewmodel.blockPaginationForDown == 0
                && viewmodel.blockPaging == false {
                viewmodel.fetchItem.onNext(.down)
            }
            else if position < upLimitOffset
                        && viewmodel.blockPaginationForUp == 0
                        && viewmodel.blockPaging == false {
                viewmodel.fetchItem.onNext(.up)
            }
           
            
        }
        
    }
    
    
    
    
}
