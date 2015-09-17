//
//  ParseUtils.h
//  Bangarang
//
//  Created by Thales Pereira on 9/10/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseUtils : NSObject

+ (PFQuery *)requests;
+ (PFQuery *)friends:(NSArray *)facebookFriends;
+ (void)request:(NSString *)requestType ToFriend:(PFUser *)friend onSuccess:(void(^)(void))onSuccess onRequestAlreadyReceived:(void (^)(void))onRequestAlreadyReceived;
+ (void)makeRelation:(NSString *)relation withFriend:(PFUser *)friend;
+ (void)confirmRequest:(PFUser *)friend onSuccess:(void (^)(void))onSuccess onRequestNotFound:(void (^)(void))onRequestNotFound;
+ (void)removeRequest:(NSString *)requestType ToFriend:(PFUser *)friend;

@end
