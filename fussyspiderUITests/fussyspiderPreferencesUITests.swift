//
//  fussyspiderPreferencesUITests.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/16/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import XCTest

class fussyspiderPreferencesUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        app.navigationBars["fussyspider"].buttons["Prefs"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    func testCancelButton() {
        XCTAssertTrue(app.navigationBars["Preferences"].buttons["Cancel"].exists)
        app.navigationBars["Preferences"].buttons["Cancel"].tap()
        XCTAssertTrue(app.navigationBars["fussyspider"].exists)
    }
    
    func testSaveButton() {
        XCTAssertTrue(app.navigationBars["Preferences"].buttons["Save"].exists)
        app.navigationBars["Preferences"].buttons["Save"].tap()
        XCTAssertTrue(app.navigationBars["fussyspider"].exists)
    }
    
    func testStarredToggle() {
        XCTAssertTrue(app.switches["Starred Tasks Toggle"].exists)
    }
    
    func testFinishedToggle() {
        XCTAssertTrue(app.switches["Finished Tasks Toggle"].exists)
    }
    
    func testFrequencySlider() {
        XCTAssertTrue(app.sliders["Frequency slider"].exists)
    }
    
    func testThemeSelect() {
        XCTAssertTrue(app.pickers["Theme selector"].exists)
    }
}
