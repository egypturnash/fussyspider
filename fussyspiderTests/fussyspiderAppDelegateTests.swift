//
//  fussyspiderAppDelegateTests.swift
//  fussyspiderTests
//
//  Created by Evan Ostroski on 8/3/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import XCTest
import EventKit
@testable import fussyspider

class fussyspiderAppDelegateTests: XCTestCase {
    
    let testDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitEventStore() {
        testDelegate!.eventStore = nil
        testDelegate!.initEventStore()
        XCTAssertTrue(testDelegate!.eventStore != nil)
    }
    
    func testRequestEventAccess() {
        testDelegate!.requestEventAccess()
        //XCTAssertTrue(testDelegate!.eventStore!.authorizationStatusForEntityType(EKEntityType.Reminder) == EKAuthorizationStatus.Authorized)
    }
    
    func testFetchReminders() {
        testDelegate!.fetchReminders()
        XCTAssertTrue(testDelegate!.reminders.count > 0)
    }
    
    func testExtractTags() {
        let testInput = "hi #this should h#ve only #two hashtags#"
        let testResult = ["#this", "#two"]
        XCTAssertEqual(testDelegate!.extractTags(testInput), testResult)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
