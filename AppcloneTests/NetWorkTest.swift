//
//  NetWorkTest.swift
//  BuzzniHwTests
//
//  Created by sangmin han on 2022/05/27.
//

import XCTest
@testable import RxSwift
@testable import RxCocoa
@testable import RxTest
@testable import RxNimble
@testable import BuzzniHw





class MockTimeLineService : TimeLineServiceDelegate {
    func fetch(base_time: String, time_size: Int, direction: FetchDirection) -> Observable<TimeLineModel> {
        return Observable<TimeLineModel>.create{ seal in
            guard let dataPath = Bundle.main.path(forResource: "mockup", ofType: ".json") else {
                return Disposables.create()
            }
            
            guard let jsonString = try? String(contentsOfFile: dataPath) else {
                return Disposables.create()
            }
            
            let decoder = JSONDecoder()
            let data = jsonString.data(using: .utf8)
            guard let data = data, let model = try? decoder.decode(TimeLineModel.self, from: data) else {
                return Disposables.create()
            }
            
            seal.onNext(model)
            seal.onCompleted()
            
            return Disposables.create()
        }
    }
    
    
    
}

class NetWorkTest: XCTestCase {
    
    
    
    
   
    let baseUrl = "http://item.assignment.dev-k8s.buzzni.net/timeline?"
    var disposebag = DisposeBag()
    
    func testQueryUrl() {
        //given
        let baseNetWorkService = BaseNetworkService()
        
        
        
        //when
        let (requestUrl,_ ) = baseNetWorkService.getRequestURL(method: .GET, baseUrl: baseUrl, parameter: ["a" : "b",
                                                                                                           "d" : 1,
                                                                                                           "e" : 1.0])
        
        guard let requestUrl = requestUrl else {
            XCTAssertThrowsError("no request URL")
            return
        }
        
        
        
        
        //then
        let url = requestUrl.url!
        
        
        XCTAssertEqual(valueOf(url: url, "a")!,"b")
        XCTAssertEqual(valueOf(url: url, "d")!,"1")
        XCTAssertEqual(valueOf(url: url, "e")!,"1.0")
        
        
    }
    
    func valueOf(url : URL,_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: url.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
    
    
    
    func testObservableReturn(){
        
        //given
        let mockTimeLineService = MockTimeLineService()
        
        //when
        mockTimeLineService.fetch(base_time: "ddd", time_size: 4, direction: .up)
            .subscribe(onNext : { [unowned self] model in
                //then
                
                XCTAssertEqual(model.before_live[0].time, "202205271400")
                XCTAssertEqual(model.before_live[0].data[0].id, 11018944)
                XCTAssertEqual(model.before_live[0].data[0].sametime.count, 0)
                XCTAssertEqual(model.before_live[0].data[3].sametime[0].id, 10998915)
            })
            .disposed(by: disposebag)
       
        
        
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
