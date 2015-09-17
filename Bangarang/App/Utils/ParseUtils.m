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

+ (PFQuery *)friends:(NSArray *)facebookFriends {
    PFQuery *query = [PFUser query];
    [query whereKey:kUserFacebookIdKey containedIn:facebookFriends];
    
    return query;
}

+ (void)confirmRequest:(PFUser *)friend onSuccess:(void (^)(void))onSuccess onRequestNotFound:(void (^)(void))onRequestNotFound {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:kRequestClass];
    
    [query whereKey:kRequestFromUser equalTo:friend];
    [query whereKey:kRequestToUser equalTo:user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] > 0) {
                PFObject *request = objects[0];
                request[kRequestAccepted] = @YES;
                [request saveInBackground];
                
                if ([request[kRequestType] isEqualToString:kRequestTypeBang]) {
                    [self makeRelation:kRequestTypeBang withFriend:friend];
                } else if ([request[kRequestType] isEqualToString:kRequestTypeHook]) {
                    [self makeRelation:kRequestTypeHook withFriend:friend];
                }
                
                onSuccess();
            } else {
                onRequestNotFound();
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
    
    // Remove from the bangs list when adding to the hook up list
    if (relation == kRequestTypeHook) {
        PFRelation *userRelationQuery = [user relationForKey:kRequestTypeBang];
        [userRelationQuery removeObject:friend];
    }
    
    [user saveInBackground];
}

+ (void)request:(NSString *)requestType ToFriend:(PFUser *)friend onSuccess:(void(^)(void))onSuccess onRequestAlreadyReceived:(void (^)(void))onRequestAlreadyReceived {
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser] = [PFUser currentUser];
    request[kRequestToUser]   = friend;
    request[kRequestType]     = requestType;
    request[kRequestAccepted] = @NO;
    
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            onSuccess();
        } else {
            onRequestAlreadyReceived();
        }
    }];
}

+ (void)removeRequest:(NSString *)requestType ToFriend:(PFUser *)friend {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:kRequestClass];
    
    [query whereKey:kRequestFromUser equalTo:user];
    [query whereKey:kRequestToUser equalTo:friend];
    [query whereKey:kRequestType equalTo:requestType];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *request = [objects firstObject];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
                [request delete];
            });
        }
    }];
}

@end
