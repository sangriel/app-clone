//
//  DataParsingTest.swift
//  BuzzniHwTests
//
//  Created by sangmin han on 2022/05/27.
//

import XCTest
@testable import BuzzniHw







class DataParsingTest: XCTestCase {
    
    
    var jsonString : String = ""
    
    
    override func setUp() {
        
        guard let dataPath = Bundle.main.path(forResource: "mockup", ofType: ".json") else {
            return
        }
        
        guard let str = try? String(contentsOfFile: dataPath) else {
            return
        }
        self.jsonString = str
        
    }
    
    
    func testTimeLineModelParsing(){
        
        //when
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        guard let data = data, let model = try? decoder.decode(TimeLineModel.self, from: data) else {
            print("failed")
            XCTAssertFalse(true, "failed to decode model")
//            assert(false, "failed to decode")
            return
        }
        
        
        //then
        XCTAssertEqual(model.before_live[0].time, "202205271400")
        XCTAssertEqual(model.before_live[0].data[0].id, 11018944)
        XCTAssertEqual(model.before_live[0].data[0].sametime.count, 0)
        XCTAssertEqual(model.before_live[0].data[3].sametime[0].id, 10998915)
        
        
        
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
