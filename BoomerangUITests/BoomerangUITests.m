//
//  BoomerangUITests.m
//  BoomerangUITests
//
//  Created by Thales Pereira on 9/24/15.
//  Copyright © 2015 Gennovacap. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Parse/Parse.h>

#import "Constants.h"

#import "FriendsManager.h"
#import "ParseUtils.h"

@interface BoomerangUITests : XCTestCase {
    FriendsManager *friendsManager;
    
    PFUser *currentUser;
    PFUser *friend1;
    PFUser *friend2;
    PFUser *friend3;
    
    NSTimeInterval kDefaultWaitForExpectationsTimeout;
}

@end

@implementation BoomerangUITests

- (void)setUp {
    [super setUp];
    
    kDefaultWaitForExpectationsTimeout = 20.0;
    
    friendsManager = [[FriendsManager alloc] init];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSendABangToAFriend {
    [[[[XCUIApplication alloc] init].tables.cells containingType:XCUIElementTypeStaticText identifier:@"Dick Thurnescu"].buttons[@"ButtonBomb"] tap];
    
}

@end
