//
//  UtilitiesTests.swift
//  fussyspider
//
//  Created by Evan Ostroski on 8/20/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import XCTest
import EventKit
@testable import fussyspider

class UtilitiesTests: XCTestCase {
    
    let testDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExtractTags() {
        let testInput = "hi #this should h#ve only #two hashtags#"
        let testResult = ["this", "two"]
        XCTAssertEqual(extractTags(testInput), testResult)
    }

    func testFetchReminders() {
        let testTags = ["#test", "#two"]
        fetchReminders(testTags, completion: {
            XCTAssertTrue(self.testDelegate.fussyReminders.count > 0)
        })        
    }
    
    func testRequestEventAccess() {
        requestEventAccess(authorized: {
                XCTAssertTrue(EKEventStore.authorizationStatusForEntityType(.Reminder) == .Authorized)
        })
    }
    
    func testCheckAuthorizationStatus() {
        requestEventAccess(authorized: {
            checkAuthorizationStatus(authorized: {
                XCTAssertTrue(true)
            })
        })        
    }
}
