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
+ (void)request:(NSString *)requestType ToFriend:(PFUser *)friend;
+ (void)makeRelation:(NSString *)relation withFriend:(PFUser *)friend;
+ (void)confirmRequest:(PFUser *)friend;

@end
