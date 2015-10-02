//
//  RequestsUITests.swift
//  Boomerang
//
//  Created by Thales Pereira on 9/28/15.
//  Copyright © 2015 Gennovacap. All rights reserved.
//

import XCTest

class RequestsUITests: XCTestCase {
    
    let helen = "U3tQTKjE51"
    let mike = "ssCgbcjI89"
    let james = "hAN4aHu9N1"
    let dick = "gx8c9DvEBV"
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        XCUIApplication().terminate()
        
        self.removeAllRequests()
        self.removeAllRelations()
        
        super.tearDown()
    }
    
    func testSendBangRequest() {
        let app = XCUIApplication()
        app.launch()
        
        let cell = app.tables.cells.containingType(.StaticText, identifier:"Mike Sadanman")
            
        cell.buttons["ButtonBomb"].tap()
        
        // Waiting for screen
        XCTAssert(app.staticTexts["WAITING FOR"].exists)
        XCTAssert(app.staticTexts["Mike"].exists)
        XCTAssert(app.staticTexts["TO CONFIRM"].exists)
        
        XCTAssert(cell.buttons["ButtonBombSelected"].exists)
    }
    
    func testConfirmBangRequest() {
        self.createRequest(kRequestTypeBang,
            fromUser: mike,
            toUser: helen,
            fromUserRead: false,
            toUserRead: false,
            accepted: false)
        
        let app = XCUIApplication()
        app.launch()
        
        let cell = app.tables.cells.containingType(.StaticText, identifier:"Mike Sadanman")
        
        cell.buttons["ButtonBomb"].tap()
        
        XCTAssert(cell.buttons["ButtonBoomerang"].exists)
    }
    
    func testConfirmedBangRequest() {
        self.createRequest(kRequestTypeBang,
            fromUser: helen,
            toUser: mike,
            fromUserRead: false,
            toUserRead: false,
            accepted: true)
        
        let app = XCUIApplication()
        app.launch()
        
        // Alerts
        NSThread.sleepForTimeInterval(3)
        XCTAssert(app.navigationBars["Browse"].buttons["1"].exists)
        
        let cell = app.tables.cells.containingType(.StaticText, identifier:"Mike Sadanman")
        
        XCTAssert(cell.buttons["ButtonBoomerang"].exists)
    }
    
    func testSendHookRequest() {
        self.createRelation(kRequestTypeBang,
            fromUser: helen,
            toUser: mike)
        
        let app = XCUIApplication()
        app.launch()
        
        let cell = app.tables.cells.containingType(.StaticText, identifier:"Mike Sadanman")
        
        cell.buttons["ButtonBoomerang"].tap()
        
        app.buttons["ButtonNo"].tap()
        
        cell.buttons["ButtonBoomerang"].tap()
        
        app.buttons["ButtonBack"].tap()
        
        cell.buttons["ButtonBoomerang"].tap()
        
        app.buttons["ButtonHeartSelected"].tap()
        
        NSThread.sleepForTimeInterval(2)
        
        XCTAssert(cell.buttons["ButtonBoomerangSelected"].exists)
    }
    
    func testConfirmHookRequest() {
        self.createRelation(kRequestTypeBang,
            fromUser: helen,
            toUser: mike)
        
        self.createRequest(kRequestTypeHook,
            fromUser: mike,
            toUser: helen,
            fromUserRead: false,
            toUserRead: false,
            accepted: false)
        
        let app = XCUIApplication()
        app.launch()
        
        // Alerts
        NSThread.sleepForTimeInterval(3)
        XCTAssert(app.navigationBars["Browse"].buttons["1"].exists)
        
        let cell = app.tables.cells.containingType(.StaticText, identifier:"Mike Sadanman")
        
        cell.buttons["ButtonBoomerang"].tap()
        
        app.buttons["ButtonHeartSelected"].tap()
        
        NSThread.sleepForTimeInterval(2)
        
        XCTAssert(app.images["Boom"].exists)
        
        NSThread.sleepForTimeInterval(2)
        
        app.buttons["ButtonBack"].tap()
        
        NSThread.sleepForTimeInterval(4)
        
        XCTAssert(cell.buttons["ButtonHeartSelected"].exists)
    }
    
    func testConfirmedHookRequest() {
        self.createRelation(kRequestTypeBang,
            fromUser: helen,
            toUser: mike)
        
        self.createRequest(kRequestTypeHook,
            fromUser: helen,
            toUser: mike,
            fromUserRead: false,
            toUserRead: true,
            accepted: true)
        
        let app = XCUIApplication()
        app.launch()
        
        NSThread.sleepForTimeInterval(2)
        
        XCTAssert(app.images["Boom"].exists)
        
        NSThread.sleepForTimeInterval(2)
        
        app.buttons["ButtonBack"].tap()
        
        let cell = app.tables.cells.containingType(.StaticText, identifier:"Mike Sadanman")
        
        XCTAssert(cell.buttons["ButtonHeartSelected"].exists)
    }
    
    func testMultipleConfirmedHookRequests() {
        self.createRelation(kRequestTypeBang,
            fromUser: helen,
            toUser: mike)
        
        self.createRequest(kRequestTypeHook,
            fromUser: helen,
            toUser: mike,
            fromUserRead: false,
            toUserRead: true,
            accepted: true)
        
        self.createRelation(kRequestTypeBang,
            fromUser: helen,
            toUser: dick)
        
        self.createRequest(kRequestTypeHook,
            fromUser: helen,
            toUser: dick,
            fromUserRead: false,
            toUserRead: true,
            accepted: true)
        
        self.createRelation(kRequestTypeBang,
            fromUser: helen,
            toUser: james)
        
        self.createRequest(kRequestTypeHook,
            fromUser: helen,
            toUser: james,
            fromUserRead: false,
            toUserRead: true,
            accepted: true)
        
        let app = XCUIApplication()
        app.launch()
        
        
        NSThread.sleepForTimeInterval(2)
        
        XCTAssert(app.images["Boom"].exists)
        
        NSThread.sleepForTimeInterval(2)
        
        app.buttons["ButtonBack"].tap()
        
        
        NSThread.sleepForTimeInterval(2)
        
        XCTAssert(app.images["Boom"].exists)
        
        NSThread.sleepForTimeInterval(2)
        
        app.buttons["ButtonBack"].tap()
        
        
        NSThread.sleepForTimeInterval(2)
        
        XCTAssert(app.images["Boom"].exists)
        
        NSThread.sleepForTimeInterval(2)
        
        app.buttons["ButtonBack"].tap()
        
        
        var cell = app.tables.cells.containingType(.StaticText, identifier:"Mike Sadanman")
        
        XCTAssert(cell.buttons["ButtonHeartSelected"].exists)
        
        cell = app.tables.cells.containingType(.StaticText, identifier:"Dick Thurnescu")
        
        XCTAssert(cell.buttons["ButtonHeartSelected"].exists)
        
        cell = app.tables.cells.containingType(.StaticText, identifier:"James Putnamsky")
        
        XCTAssert(cell.buttons["ButtonHeartSelected"].exists)
    }
    
    // Helper Methods
    
    func createRequest(type: String, fromUser: String, toUser: String, fromUserRead: Bool, toUserRead: Bool, accepted: Bool) {
        let params = "type=\(type)&fromUser=\(fromUser)&toUser=\(toUser)&fromUserRead=\(fromUserRead)&toUserRead=\(toUserRead)&accepted=\(accepted)"
        
        makeRequest("requests", method: "POST", params: params)
    }
    
    func createRelation(type: String, fromUser: String, toUser: String) {
        let params = "type=\(type)&fromUser=\(fromUser)&toUser=\(toUser)"
        
        makeRequest("relations", method: "POST", params: params)
    }
    
    func removeAllRequests() {
        makeRequest("requests/all", method: "DELETE", params: nil)
    }

    func removeAllRelations() {
        makeRequest("relations/all", method: "DELETE", params: nil)
    }
    
    func makeRequest(url: String, method: String, params: String?) {
        let expectation = expectationWithDescription("Create Request")
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8000/\(url)")!)
        request.HTTPMethod = method
        
        if ((params) != nil) {
            request.HTTPBody = params!.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            XCTAssert(error == nil)
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(10) { error in
            print(error)
        }
    }
    
}
