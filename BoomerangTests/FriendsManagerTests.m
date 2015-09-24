//
//  FriendsManagerTests.m
//  Bangarang
//
//  Created by Thales Pereira on 9/18/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "FriendsManager.h"
#import "ParseUtils.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface FriendsManagerTests : XCTestCase {
    FriendsManager *friendsManager;
    
    PFUser *currentUser;
    PFUser *friend1;
    PFUser *friend2;
    PFUser *friend3;
    
    NSTimeInterval kDefaultWaitForExpectationsTimeout;
}

@end

@implementation FriendsManagerTests

- (void)setUp {
    [super setUp];

    kDefaultWaitForExpectationsTimeout = 10.0;
    
    friendsManager = [[FriendsManager alloc] init];
    
    XCTestExpectation *expectationLogin = [self expectationWithDescription:@"Parse login"];
    
    [PFUser logInWithUsernameInBackground:@"rt07x263FGsLxK1BpV3pgsj5I" password:@"helen"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [expectationLogin fulfill];
                                        } else {
                                            NSLog(@"Parse login failed: %@", error);
                                        }
                                    }];
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectationsTimeout handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" containedIn:@[@"tlfJPo1hUg", @"MnoZreXejV", @"oaCMxqZx5m"]];
    
    XCTestExpectation *expectationFriends = [self expectationWithDescription:@"Parse query"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        friend1 = [objects objectAtIndex:0];
        friend2 = [objects objectAtIndex:1];
        friend3 = [objects objectAtIndex:2];
        
        [expectationFriends fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectationsTimeout handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}

- (void)tearDown {
    [super tearDown];
    
    friendsManager = NULL;
    
    [self deleteAllRequests];
}

- (void)testUsersRelation {
    kFriendRelationIndex relation = [friendsManager friendRelation:friend1];

    XCTAssertEqual(relation, kFriendNoRelation);
    
    [friendsManager addFriendToBangRequestsSent:friend1];
    relation = [friendsManager friendRelation:friend1];
    
    XCTAssertEqual(relation, kFriendBangRequestSent);
    
    [friendsManager removeFriendFromBangRequestsSent:friend1];
    [friendsManager addFriendToBangs:friend1];
    relation = [friendsManager friendRelation:friend1];
    
    XCTAssertEqual(relation, kFriendBangRelation);
    
    [friendsManager removeFriendFromBangs:friend1];
    [friendsManager addFriendToHookRequestsSent:friend1];
    relation = [friendsManager friendRelation:friend1];
    
    XCTAssertEqual(relation, kFriendHookRequestSent);
    
    [friendsManager removeFriendFromHookRequestsSent:friend1];
    [friendsManager addFriendToHooks:friend1];
    relation = [friendsManager friendRelation:friend1];
    
    XCTAssertEqual(relation, kFriendHookRelation);
}

- (void)testShouldNotifyCurrentUserOnBangRequestsSent {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeBang;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @NO;
    
    BOOL notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @NO;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @YES;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssert(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @YES;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssert(notify);
}

- (void)testShouldNotifyCurrentUserOnBangRequestsReceived {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = friend1;
    request[kRequestToUser]       = [PFUser currentUser];
    request[kRequestType]         = kRequestTypeBang;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @NO;
    
    BOOL notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @YES;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @NO;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
}

- (void)testShouldNotifyCurrentUserOnHookRequestsSent {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeHook;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @NO;
    
    BOOL notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @NO;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @YES;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssert(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @YES;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssert(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @YES;
    
    XCTAssert(notify);
}

- (void)testShouldNotifyCurrentUserOnHookRequestsReceived {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = friend1;
    request[kRequestToUser]       = [PFUser currentUser];
    request[kRequestType]         = kRequestTypeHook;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @NO;
    
    BOOL notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssert(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @NO;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @YES;
    
    XCTAssertFalse(notify);
}

- (void)testIfRequestIsDeletedOnParseDataOnBangRequests {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeBang;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @NO;
    
    XCTAssert([self saveAndVerifyIfRequestExists:request]);
    
    [self deleteAllRequests];
    
    request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeBang;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @YES;
    
    XCTAssert([self saveAndVerifyIfRequestExists:request]);
    
    [self deleteAllRequests];
    
    request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeBang;
    
    request[kRequestFromUserRead] = @YES;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @YES;
    
    XCTAssertFalse([self saveAndVerifyIfRequestExists:request]);
    
    [self deleteAllRequests];
}

- (void)testIfRequestIsDeletedOnParseDataOnHookRequests {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeHook;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @NO;
    
    XCTAssert([self saveAndVerifyIfRequestExists:request]);
    
    [self deleteAllRequests];
    
    request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeHook;;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @YES;
    
    XCTAssert([self saveAndVerifyIfRequestExists:request]);
    
    [self deleteAllRequests];
    
    request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeHook;
    
    request[kRequestFromUserRead] = @YES;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @YES;
    
    XCTAssert([self saveAndVerifyIfRequestExists:request]);
    
    [self deleteAllRequests];
    
    request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeHook;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @YES;
    
    XCTAssert([self saveAndVerifyIfRequestExists:request]);
    
    [self deleteAllRequests];
    
    request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeHook;
    
    request[kRequestFromUserRead] = @YES;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @YES;
    
    XCTAssertFalse([self saveAndVerifyIfRequestExists:request]);
    
    [self deleteAllRequests];
}

/*- (void)testUserCanRemoveABangRequest {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeBang;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @NO;
    
    XCTAssert([self saveRequest:request]);
    
    [ParseUtils removeRequest:kRequestTypeBang toFriend:friend1 onSuccess:^{
        
    }];
    
    XCTAssertFalse([self verifyIfRequestExists:request]);
}*/

- (BOOL)saveRequest:(PFObject *)request {
    PFObject *myRequest = request;
    __block BOOL success = YES;
    
    XCTestExpectation *expectationSave = [self expectationWithDescription:@"Save Request"];
    
    [myRequest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            success = NO;
        }
        [expectationSave fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectationsTimeout handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    return success;
}

- (BOOL)verifyIfRequestExists:(PFObject *)request {
    __block BOOL exists = YES;
    
    XCTestExpectation *expectationQuery = [self expectationWithDescription:@"Query Request"];
    
    NSString *requestId = [request objectId];
    
    PFQuery *query = [PFQuery queryWithClassName:kRequestClass];
    
    [query getObjectInBackgroundWithId:requestId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        if (!object){
            exists = NO;
        }
        
        [expectationQuery fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectationsTimeout handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    return exists;
}

- (BOOL)saveAndVerifyIfRequestExists:(PFObject *)request {
    [self saveRequest:request];
    return [self verifyIfRequestExists:request];
}

- (BOOL)deleteAllRequests {
    PFQuery *query = [PFQuery queryWithClassName:kRequestClass];
    
    XCTestExpectation *expectationQuery = [self expectationWithDescription:@"Query Request"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFObject *request in objects) {
            [request delete];
        }
        
        [expectationQuery fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectationsTimeout handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    return YES;
}

@end
