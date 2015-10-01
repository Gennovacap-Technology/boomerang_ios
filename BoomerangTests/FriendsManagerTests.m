//
//  FriendsManagerTests.m
//  Bangarang
//
//  Created by Thales Pereira on 9/18/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Parse.h"

#import "ParseUtils.h"
#import "FriendsManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface FriendsManagerTests : XCTestCase {
    FriendsManager *friendsManager;
    ParseUtils *parseUtils;
    
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

    kDefaultWaitForExpectationsTimeout = 20.0;
    //self.continueAfterFailure = NO;
    
    [Parse setApplicationId:@"kb5KPJAtHIlxwXcSXBSsENdU8ysMZ6oTAGYQUZpv"
                  clientKey:@"xV1Xcwz6KMcUIZMAhey5U1raWRbWH16WIrrYVUQy"];

    friendsManager = [[FriendsManager alloc] init];
    
    XCTestExpectation *expectationLogin = [self expectationWithDescription:@"Parse login"];
    
    [PFUser logInWithUsernameInBackground:@"ItcCxuUzPBFehvQl0NPfHYh0P" password:@"helen"
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
    
    [query whereKey:@"objectId" containedIn:@[@"hAN4aHu9N1", @"ssCgbcjI89", @"gx8c9DvEBV"]];
    
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
    
    //[PFUser logOut];
    
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
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @YES;
    
    notify = [friendsManager shouldNotifyCurrentUser:request];
    
    XCTAssertFalse(notify);
    
    request[kRequestFromUserRead] = @YES;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @YES;
    
    XCTAssertFalse(notify);
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

- (void)testUserCanRemoveABangRequest {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeBang;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @NO;
    request[kRequestAccepted]     = @NO;
    
    XCTAssert([self saveRequest:request]);
    
    XCTestExpectation *expectationRemove = [self expectationWithDescription:@"Remove Request"];
    
    [self removeRequest:kRequestTypeBang toFriend:friend1 onSuccess:^{
        [expectationRemove fulfill];
    } onRequestAccepted:^{
        [expectationRemove fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectationsTimeout handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    XCTAssertFalse([self verifyIfRequestExists:request]);
    
    request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser]     = [PFUser currentUser];
    request[kRequestToUser]       = friend1;
    request[kRequestType]         = kRequestTypeBang;
    
    request[kRequestFromUserRead] = @NO;
    request[kRequestToUserRead]   = @YES;
    request[kRequestAccepted]     = @NO;
    
    XCTAssert([self saveRequest:request]);
    
    expectationRemove = [self expectationWithDescription:@"Remove Request"];
    
    [self removeRequest:kRequestTypeBang toFriend:friend1 onSuccess:^{
        [expectationRemove fulfill];
    } onRequestAccepted:^{
        [expectationRemove fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kDefaultWaitForExpectationsTimeout handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    XCTAssertFalse([self verifyIfRequestExists:request]);
}

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
    
    //[NSThread sleepForTimeInterval:2];
    
    return [self verifyIfRequestExists:request];
}

- (void)removeRequest:(NSString *)requestType
             toFriend:(PFUser *)friend
            onSuccess:(void(^)(void))onSuccess
    onRequestAccepted:(void(^)(void))onRequestAccepted {
    
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:kRequestClass];
    
    [query whereKey:kRequestFromUser equalTo:user];
    [query whereKey:kRequestToUser equalTo:friend];
    [query whereKey:kRequestType equalTo:requestType];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            if ([object[kRequestAccepted] boolValue]) {
                onRequestAccepted();
            } else {
                [object delete];
                onSuccess();
            }
        } else {
            NSLog(@"The getFirstObject request failed.");
        }
    }];
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
