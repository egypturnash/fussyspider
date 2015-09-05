//
//  MainViewUITests.swift
//  fussyspiderUITests
//
//  Created by Evan Ostroski on 8/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import XCTest

class MainViewUITests: XCTestCase {
  
  let app = XCUIApplication()
  
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  // Use recording to get started writing UI tests.
  // Use XCTAssert and related functions to verify your tests produce the correct results.
  func testPrefsButton() {
    XCTAssertTrue(app.navigationBars["fussyspider"].buttons["Prefs"].exists)
    app.navigationBars["fussyspider"].buttons["Prefs"].tap()
    XCTAssertTrue(app.navigationBars["Preferences"].exists)
  }
  
  func testAddTaskButton() {
    XCTAssertTrue(app.navigationBars["fussyspider"].buttons["Add"].exists)
    app.navigationBars["fussyspider"].buttons["Add"].tap()
    XCTAssertTrue(app.navigationBars["Edit Task"].exists)
    
  }
  
  func testTagFilterButton() {
    let toolbarsQuery = app.toolbars
    XCTAssertTrue(toolbarsQuery.buttons["tag filter"].exists)
    toolbarsQuery.buttons["tag filter"].tap()
    XCTAssertTrue(app.navigationBars["Select Tags"].exists)
  }
  
  func testAddTagButton() {
    let toolbarsQuery = app.toolbars
    XCTAssertTrue(toolbarsQuery.buttons["Add"].exists)
    toolbarsQuery.buttons["Add"].tap()
    XCTAssertTrue(app.navigationBars["Edit Tag"].exists)
  }
  
  func testKalindaButton() {
    let toolbarsQuery = app.toolbars
    XCTAssertTrue(toolbarsQuery.buttons["birb!"].exists)
    toolbarsQuery.buttons["birb!"].tap()
    XCTAssertTrue(app.navigationBars["Kalinda"].exists)
  }
  
  func testMainTableView() {
    let table = app.scrollViews.childrenMatchingType(.Table).element
    XCTAssertTrue(table.exists)
  }
}
