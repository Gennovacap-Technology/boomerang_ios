//
//  ParseUtils.m
//  Bangarang
//
//  Created by Thales Pereira on 9/10/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "ParseUtils.h"

@implementation ParseUtils

+ (PFQuery *)requests {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *queryFromUser = [PFQuery queryWithClassName:kRequestClass];
    [queryFromUser whereKey:kRequestFromUser equalTo:user];

    PFQuery *queryToUser = [PFQuery queryWithClassName:kRequestClass];
    [queryToUser whereKey:kRequestToUser equalTo:user];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryToUser, queryFromUser]];
    
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}

+ (void)confirmRequest:(PFUser *)friend {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:kRequestClass];
    
    [query whereKey:kRequestFromUser equalTo:friend];
    [query whereKey:kRequestToUser equalTo:user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *request = objects[0];
            request[kRequestAccepted] = @YES;
            [request saveInBackground];
            
            if ([request[kRequestType] isEqualToString:kRequestTypeBang]) {
                [self makeRelation:kRequestTypeBang withFriend:friend];
            } else if ([request[kRequestType] isEqualToString:kRequestTypeHook]) {
                [self makeRelation:kRequestTypeHook withFriend:friend];
            }
        } else {
            NSLog(@"Error while confirm request");
        }
    }];
}

+ (void)makeRelation:(NSString *)relation withFriend:(PFUser *)friend {
    PFUser *user = [PFUser currentUser];
    
    PFRelation *userRelationQuery = [user relationForKey:relation];
    [userRelationQuery addObject:friend];
    
    // Remove from bangs list when add to hook up list
    if (relation == kRequestTypeHook) {
        PFRelation *userRelationQuery = [user relationForKey:kRequestTypeBang];
        [userRelationQuery removeObject:friend];
    }
    
    [user saveInBackground];
}

+ (void)request:(NSString *)requestType ToFriend:(PFUser *)friend {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser] = [PFUser currentUser];
    request[kRequestToUser]   = friend;
    request[kRequestType]     = requestType;
    request[kRequestAccepted] = @NO;
    
    [request saveInBackground];
}

@end
