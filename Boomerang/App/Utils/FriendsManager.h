//
//  RequestsManager.h
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "Parse.h"

@interface FriendsManager : NSObject

+ (id)sharedManager;

- (void)loadFriends:(void (^)(void))onSuccess;
- (void)loadRequests:(void (^)(NSUInteger))onSuccess;
- (void)loadRelations;

- (NSMutableArray *)getFriendsOfCurrentGender;
- (PFUser *)getFriendOfCurrentGenderAtIndex:(NSUInteger)index;

- (void)setCurrentGender:(NSString *)gender;

- (kFriendRelationIndex)friendRelation:(PFUser *)friend;

- (BOOL)shouldNotifyCurrentUser:(PFObject *)request;
- (void)setRequestAsRead:(PFObject *)request;

- (BOOL)receivedBangRequestFromFriend:(PFUser *)friend;
- (BOOL)receivedHookRequestFromFriend:(PFUser *)friend;

- (void)addFriendToHooks:(PFUser *)friend;
- (void)addFriendToBangs:(PFUser *)friend;
- (void)addFriendToHookRequestsSent:(PFUser *)friend;
- (void)addFriendToBangRequestsSent:(PFUser *)friend;

- (void)removeFriendFromHooks:(PFUser *)friend;
- (void)removeFriendFromBangs:(PFUser *)friend;
- (void)removeFriendFromHookRequestsSent:(PFUser *)friend;
- (void)removeFriendFromBangRequestsSent:(PFUser *)friend;
- (void)removeFriendFromHookRequestsReceived:(PFUser *)friend;
- (void)removeFriendFromBangRequestsReceived:(PFUser *)friend;

@end
