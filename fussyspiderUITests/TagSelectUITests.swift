//
//  TagSelectUITests.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/16/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import XCTest

class TagSelectUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        app.toolbars.buttons["tag filter"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCancelButton() {
        XCTAssertTrue(app.navigationBars["Select Tags"].buttons["Cancel"].exists)
        app.navigationBars["Select Tags"].buttons["Cancel"].tap()
        XCTAssertTrue(app.navigationBars["fussyspider"].exists)
    }
    func testSaveButton() {
        XCTAssertTrue(app.navigationBars["Select Tags"].buttons["Save"].exists)
        app.navigationBars["Select Tags"].buttons["Save"].tap()
        XCTAssertTrue(app.navigationBars["fussyspider"].exists)
    }
    func testTagList() {
        XCTAssertTrue(app.tables["Empty list"].exists)        
    }
}
