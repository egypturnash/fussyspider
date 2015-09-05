//
//  TaskUITests.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/16/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import XCTest

class TaskUITests: XCTestCase {
  
  let app = XCUIApplication()
  
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    app.navigationBars["fussyspider"].buttons["Add"].tap()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCancelButton() {
    XCTAssertTrue(app.navigationBars["Edit Task"].buttons["Cancel"].exists)
    app.navigationBars["Edit Task"].buttons["Cancel"].tap()
    XCTAssertTrue(app.navigationBars["fussyspider"].exists)
  }
  
  func testSaveButton() {
    XCTAssertTrue(app.navigationBars["Edit Task"].buttons["Save"].exists)
    app.navigationBars["Edit Task"].buttons["Save"].tap()
    XCTAssertTrue(app.navigationBars["fussyspider"].exists)
  }
  
  func testNameField() {
    XCTAssertTrue(app.textFields["Task Name Field"].exists)
  }
  
  func testNotesField() {
    XCTAssertTrue(app.textViews["Notes Field"].exists)
  }
  
  func testReminderField() {
    XCTAssertTrue(app.textFields["Reminder Picker"].exists)
  }
  
  func testHiddenField() {
    XCTAssertTrue(app.textFields["Hidden Picker"].exists)
  }
}
