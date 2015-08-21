//
//  TagEditUITests.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/16/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import XCTest

class fussyspiderTagEditUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        app.toolbars.buttons["Add"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTagNameField() {
        XCTAssertTrue(app.textFields["Tag Name Field"].exists)
    }
    
    func testLocationField() {
        XCTAssertTrue(app.textFields["Location Field"].exists)
    }
    
    func testSaveButton() {
        XCTAssertTrue(app.navigationBars["Edit Tag"].buttons["Save"].exists)
        app.navigationBars["Edit Tag"].buttons["Save"].tap()
        XCTAssertTrue(app.navigationBars["fussyspider"].exists)
    }
    
    func testCancelButton() {
        XCTAssertTrue(app.navigationBars["Edit Tag"].buttons["Cancel"].exists)
        app.navigationBars["Edit Tag"].buttons["Cancel"].tap()
        XCTAssertTrue(app.navigationBars["fussyspider"].exists)
    }
}
