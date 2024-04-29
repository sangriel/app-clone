//
//  VideoListViewModel.swift
//  BuzzniHw
//
//  Created by sangmin han on 2022/05/27.
//

import Foundation
import RxSwift
import RxCocoa




class ListViewModel : NSObject {
    
    
    //datas
    private var _dateViewModels : [DateCollectionViewCellViewModel] = []
    private var timeLineService : TimeLineServiceDelegate!
    private var disposebag = DisposeBag()
    //리스트의 데이터를 Any형태로 저장하여 향후 다른 뷰모델도 지원 가능하도록 생성
    private(set) var listData : [[Any]] = []
    //동신간대 상품을 딕시너리 형태로 저장하여 탐색 기능을 최소화
    private(set) var sameTimeData : [Int : [SameTimeTableCellViewModel]] = [:]
    private var currentBaseTime = Date().getLocalTime()
    private(set) var blockPaginationForUp : Int = 0
    private(set) var blockPaginationForDown : Int = 0
    private(set) var blockPaging : Bool = false
    
    
    
    enum TableUpdateType {
        case delete
        case insert
    }
    
    
    //output
    var dateViewModels = PublishSubject<[DateCollectionViewCellViewModel]>()
    var centerDateIndex = PublishSubject<Int>()
    var reloadTableView = PublishSubject<FetchDirection>()
    var reloadRowAtTableView = PublishSubject<IndexPath>()
    var insertOrDeleteTableView = PublishSubject<([IndexPath],TableUpdateType)>()
    var scrollTableViewToIndex = PublishSubject<(IndexPath,Bool)>()
    
    
    //input
    var dateSelected = PublishSubject<Int>()
    var insertOrDeleteSameTime = PublishSubject<IndexPath>()
    var fetchItem = PublishSubject<FetchDirection>()
    var tableReloadFinished = PublishSubject<Void>()
    var tableViewWillDisplayHeaderSection = PublishSubject<Int>()
    var tableViewWillDisplayIndexPath = PublishSubject<IndexPath>()
    
    
    
    
    
    
    
    
    
    init(timeLineService : TimeLineServiceDelegate){
        super.init()
        self.timeLineService = timeLineService
        
        bindInputs()
    }
    
    
    private func bindInputs(){
        
        dateSelected
            .subscribe(onNext : { [unowned self] index in
                for i in 0..<_dateViewModels.count {
                    _dateViewModels[i].isSelected = i == index
                }
                self.dateViewModels.onNext(_dateViewModels)
                self.centerDateIndex.onNext(index)
                //baseTime의 형태가  yyyyMMddHHmm이므로 앞의 8자리 yyyyMMdd 와 뒷자리에 0000을 붙여 자정시간대를 불러온다
                currentBaseTime = _dateViewModels[index].baseTime.prefix(8) + "0000"
                self.fetchItem.onNext(.center)
            })
            .disposed(by: disposebag)
        
        
        insertOrDeleteSameTime
            .subscribe(onNext : { [unowned self] indexPath in
                var temp = listData[indexPath.section][indexPath.row] as! SameTimeToggleTableCellViewModel
                if let sameTimeData = sameTimeData[temp.id] {
                    temp.isSelected = !temp.isSelected
                    listData[indexPath.section][indexPath.row] = temp
                    self.reloadRowAtTableView.onNext(indexPath)
                    
                    
                    if temp.isSelected == true {//동시간대 상품 추가
                        listData[indexPath.section].insert(contentsOf: sameTimeData, at: indexPath.row)
                        let addingIndexPath = (indexPath.row..<(indexPath.row + sameTimeData.count)).map{ IndexPath(row: $0, section: indexPath.section)}
                        self.insertOrDeleteTableView.onNext((addingIndexPath, .insert))
                    }
                    else {//동시간대 상품 삭제
                        listData[indexPath.section].removeAll { someData in
                            if let sameTimeRemoveData = someData as? SameTimeTableCellViewModel, sameTimeRemoveData.parentId == temp.id {
                                return true
                            }
                            else {
                                
                                return false
                            }
                        }
                        let deletingIndexPath = ((indexPath.row - sameTimeData.count)..<(indexPath.row)).map{ IndexPath(row: $0, section: indexPath.section)}
                        self.insertOrDeleteTableView.onNext((deletingIndexPath, .delete))
                    }
                }
            })
            .disposed(by: disposebag)
        
        
        fetchItem
            .flatMap({ [unowned self] direction -> Observable<(String,Int,FetchDirection)> in
                //방향과 현재 베이스 타임을 가지고 어느 시간대를 불러올지 계산한다
                self.blockPaging = true
                let df = DateFormatter()
                df.dateFormat = "yyyyMMddHHmm"
                
                guard var currentBaseTimeinDate = df.date(from: currentBaseTime) else {
                    return Observable.create { seal  in
                        seal.onError(CustomError.error("time not parsable"))
                        return Disposables.create()
                    }
                }
                
                if direction == .up {
                    currentBaseTimeinDate.addTimeInterval(-(60 * 60 * 4))
                    currentBaseTime = df.string(from: currentBaseTimeinDate)
                }
                else if direction == .down {
                    currentBaseTimeinDate.addTimeInterval((60 * 60 * 4))
                    currentBaseTime = df.string(from: currentBaseTimeinDate)
                }
                
                return Observable<(String,Int,FetchDirection)>.just((currentBaseTime,4,direction))
            })
            .flatMap { [unowned self] (baseTime, time_size, direction) -> Observable<(TimeLineModel,FetchDirection)> in
                //실제 API 부분
                //map으로 모델과 방향을 함께 넘겨준다
                return timeLineService.fetch(base_time: baseTime, time_size: time_size, direction: direction).map{ ($0,direction) }
            }
            .observe(on: MainScheduler.instance)//테이블 리로딩이 필요하므로 메인큐에서 구독한다.
            .subscribe(onNext : { [unowned self] timelinemodel,direction in
                //방향이 중앙일 경우 날짜를 새로 클릭하거나 혹은 처음진입하는 것이므로 이전 데이터들을 삭제한다.
                if direction == .center {
                    self.blockPaginationForUp = 0
                    self.blockPaginationForDown = 0
                    listData.removeAll()
                    sameTimeData.removeAll()
                }
                if timelinemodel.before_live.isEmpty == false {
                    self.parseNotLiveModelIntoListData(model: timelinemodel.before_live, direction: direction)
                }
                
                if timelinemodel.live.isEmpty == false {
                    self.parseLiveModelIntolistData(model: timelinemodel.live)
                }
                
                if timelinemodel.after_live.isEmpty == false {
                    self.parseNotLiveModelIntoListData(model: timelinemodel.after_live, direction: direction)
                }
                
                //추가 페이지네이션 가능여부 세팅
                if direction == .up {
                    blockPaginationForUp = timelinemodel.is_continues
                }
                else if direction == .down {
                    blockPaginationForDown = timelinemodel.is_continues
                }
                
                
                self.reloadTableView.onNext(direction)
                //처음 불렀을때
                // 방향이 중심이면서 currentBaseTime가 현재 yyyyMMddHHmm과 같다면 생방송 시점으로 스크롤
                if direction == .center && currentBaseTime.prefix(12) == Date().getLocalTime().prefix(12) {
                    if let section = listData.firstIndex(where: { $0 is [LiveSectionTableViewCellViewModel] }) {
                        self.scrollTableViewToIndex.onNext((IndexPath(row: NSNotFound, section: section), false))
                    }
                }
                //상단의 캘린더를 눌렀을 경우
                else if direction == .center {
                    if let section = listData.firstIndex(where: { data in
                        if let notLiveData = data as? [NotLiveSectionTableCellViewModel],
                           let first = notLiveData.first,
                           let type = first.type, type == "date_info" {
                            return true
                        }
                        else{
                            return false
                        }
                    }) {
                        self.scrollTableViewToIndex.onNext((IndexPath(row: NSNotFound, section: section), false))
                    }
                    //만약 맨처음 날이며 현재 날짜 기준 -3일 dateInfo를 주지 않기 때문에 맨처음 섹션으로 이동한다
                    else {
                        self.scrollTableViewToIndex.onNext((IndexPath(row: NSNotFound, section: 0), false))
                    }
                }
            },onError : { error in
                print(error)
            })
            .disposed(by: disposebag)
        
        
        
        tableReloadFinished
            .subscribe(onNext : { [unowned self] in
                self.blockPaging = false
            })
            .disposed(by: disposebag)
        
        tableViewWillDisplayIndexPath
            .flatMap({ [unowned self] indexPath -> Observable<Int> in
                if let notLiveData = listData[indexPath.section][indexPath.row] as? NotLiveSectionTableCellViewModel {
                    var centerIndex = 0
                    for i in 0..<_dateViewModels.count {
                        if _dateViewModels[i].baseTime.prefix(8) == notLiveData.time.prefix(8) {
                            _dateViewModels[i].isSelected = true
                            centerIndex = i
                        }
                        else {
                            _dateViewModels[i].isSelected = false
                        }
                    }
                    return Observable<Int>.just(centerIndex)
                }
                return Observable<Int>.just(-1)
            })
            .distinctUntilChanged()//index가 달라 졌을때만 이벤트를 방출 한다.
            .subscribe(onNext : { [unowned self] centerIndex in
                if centerIndex == -1 { return}
                self.dateViewModels.onNext(_dateViewModels)
                self.centerDateIndex.onNext(centerIndex)
            })
            .disposed(by: disposebag)
        
        
    }
    
    
    func configureDateViewModels(){
        //오늘을 기준으로 뒤에 7일 앞의 3일의 일자를 구한다 (일자,베이스타임,날짜,오늘의 여부)
        let dateArray = (-3...7).map { index -> (Int,String,String,Bool) in
            let date = Calendar.current.date(byAdding: .day, value: index, to: Date())
            let day = Calendar.current.component(.day, from: date!)
            let baseTime = String(date!.getLocalTime().prefix(8) + "0000")
            var weekday : String = ""
            switch Calendar.current.component(.weekday, from: date!) {
            case 1:
                weekday = "일"
            case 2:
                weekday = "월"
            case 3:
                weekday = "화"
            case 4:
                weekday = "수"
            case 5:
                weekday = "목"
            case 6:
                weekday = "금"
            case 7:
                weekday = "토"
            default:
                break
            }
            return (day,baseTime,weekday,index == 0)
        }
        
        //차출한 데이터로부터 뷰모델 생성
        let viewModels =  dateArray.map{ (day,baseTime,weekday,isToday) -> DateCollectionViewCellViewModel in
            return DateCollectionViewCellViewModel(isSelected: isToday, date: String(day), day: weekday, isToday: isToday,baseTime: baseTime)
        }
        
        //내부 변수에 저장 및 바인딩으로 뷰로 방출
        self._dateViewModels = viewModels
        self.dateViewModels.onNext(viewModels)
        
    }
}
extension ListViewModel {
    
    private func parseNotLiveModelIntoListData(model : [TimeLineModel.TimeLineItemListModel],direction : FetchDirection){
        //순서를 위해서 임시 저장소에 저장한 다음 한번에 추가시킨다.
        var listDataToAppend : [[Any]] = []
        
        model.forEach { timeLineItemListModel in
            let time = timeLineItemListModel.time
            
            if let data = timeLineItemListModel.data {
                var dataList : [Any] = []
                
                for timeLineItemModel in data {
                    
                    
                    let sameTime = timeLineItemModel.sametime.map { sameTimeModel -> SameTimeTableCellViewModel in
                        
                        return SameTimeTableCellViewModel(parentId: timeLineItemModel.id,
                                                          id: sameTimeModel.id,
                                                          name: sameTimeModel.name,
                                                          image: sameTimeModel.image,
                                                          low_price: sameTimeModel.low_price)
                    }
                    
                    sameTimeData[timeLineItemModel.id] = sameTime
                    let itemModel = NotLiveSectionTableCellViewModel(id: timeLineItemModel.id,
                                                                     name: timeLineItemModel.name,
                                                                     url: timeLineItemModel.url,
                                                                     shop: timeLineItemModel.shop,
                                                                     start_datetime: timeLineItemModel.start_datetime,
                                                                     end_datetime: timeLineItemModel.end_datetime,
                                                                     originPrice: timeLineItemModel.original_price,
                                                                     price: timeLineItemModel.price,
                                                                     image_list: timeLineItemModel.image_list,
                                                                     time: time,
                                                                     month: nil,
                                                                     day: nil,
                                                                     weekday_kor: nil,
                                                                     type:  nil,
                                                                     haveSameTime: !sameTime.isEmpty)
                    
                    dataList.append(itemModel)
                    if sameTime.count != 0 {
                        let sameTimeToggleViewModel = SameTimeToggleTableCellViewModel(numberOfSameTime: sameTime.count, isSelected: false,id: timeLineItemModel.id)
                        dataList.append(sameTimeToggleViewModel)
                    }
                }
                
                listDataToAppend.append(dataList)
                
            }
            else if let type = timeLineItemListModel.type , type == "date_info" {
                
                listDataToAppend.append([NotLiveSectionTableCellViewModel(id: 0,
                                                                          name: "",
                                                                          url: "",
                                                                          shop: "",
                                                                          start_datetime: "",
                                                                          end_datetime: "",
                                                                          originPrice: 0,
                                                                          price: 0,
                                                                          image_list: [],
                                                                          time: timeLineItemListModel.time,
                                                                          month: timeLineItemListModel.month!,
                                                                          day: timeLineItemListModel.day!,
                                                                          weekday_kor: timeLineItemListModel.weekday_kor!,
                                                                          type: type,
                                                                          haveSameTime: false)])
            }
        }
        
        
        if direction == .center || direction == .down {
            listData.append(contentsOf: listDataToAppend)
        }
        else {
            listData.insert(contentsOf: listDataToAppend, at: 0)
        }
    }
    
    
    private func parseLiveModelIntolistData(model : [TimeLineModel.TimeLineItemListModel]){
        if let liveData = model.first, let data = liveData.data {
            //id가 -1 인것을 빼고 뷰모델을 만든다
            //출시앱에서 현재 라이브인 것이 크게 따로 나오는 것 같은데 live의 데이터 형태를 알지 못하여 구현하지 않았다.
            let liveItemViewModels = data.filter{ $0.id != -1 }.map { item -> LiveItemCollectionViewCellViewModel in
                return LiveItemCollectionViewCellViewModel(id: item.id,
                                                           imag_list: item.image_list,
                                                           shop: item.shop,
                                                           name: item.name,
                                                           url: item.url,
                                                           price: item.price.toMoneyForm())
            }
            
            listData.append([ LiveSectionTableViewCellViewModel(count:liveData.listCount ?? 0,
                                                                liveItemViewModel: liveItemViewModels)])
            
        }
        
    }
    
    
    
    
    
    
}
