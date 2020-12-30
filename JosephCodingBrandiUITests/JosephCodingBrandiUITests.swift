//
//  JosephCodingBrandiUITests.swift
//  JosephCodingBrandiUITests
//
//  Created by Joseph_iMac on 2020/12/30.
//

import XCTest

class JosephCodingBrandiUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        
    }
    
    // 키워드 검색시 결과 확인
    func test_SearchKeywordResultAvailable() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("롯데자이언츠\n")
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 10.0))
    }
    
    // 키워드 리스트에서 사진 클릭시 상세이동 확인(첫번째사진)
    func test_SearchKeywordImgDetail() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("롯데자이언츠\n")
        app.collectionViews.cells.element(at: 1).tap()
    }
    
    // 키워드 삭제시 초기화
//    func test_SearchKeywordClear() {
//        let searchField = app.searchFields.element(boundBy: 0)
//        searchField.typeText("")
//    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
