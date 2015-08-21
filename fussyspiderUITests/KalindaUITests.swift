//
//  KalindaUITests.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/16/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import XCTest

class fussyspiderKalindaUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        app.toolbars.buttons["birb!"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDoneButton() {
        XCTAssertTrue(app.navigationBars["Kalinda"].buttons["Done"].exists)
        app.navigationBars["Kalinda"].buttons["Done"].tap()
        XCTAssertTrue(app.navigationBars["fussyspider"].exists)
    }
    
    func testSwipeLeft() {
        //TODO
    }
    
    func testSwipeRight() {
        //TODO
    }
}
