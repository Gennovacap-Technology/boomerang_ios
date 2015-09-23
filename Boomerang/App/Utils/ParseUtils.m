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
    
    [query orderByDescending:@"updatedAt"];
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}

+ (PFQuery *)friends:(NSArray *)facebookFriends {
    PFQuery *query = [PFUser query];
    [query whereKey:kUserFacebookIdKey containedIn:facebookFriends];
    
    return query;
}

+ (void)confirmRequest:(NSString *)type
              ofFriend:(PFUser *)friend
             onSuccess:(void (^)(void))onSuccess
     onRequestNotFound:(void (^)(void))onRequestNotFound {
    
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:kRequestClass];
    
    [query whereKey:kRequestFromUser equalTo:friend];
    [query whereKey:kRequestToUser equalTo:user];
    [query whereKey:kRequestType equalTo:type];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            PFObject *request = object;
            request[kRequestAccepted] = @YES;
            
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    if ([request[kRequestType] isEqualToString:kRequestTypeBang]) {
                        [self makeRelation:kRequestTypeBang withFriend:friend];
                    } else if ([request[kRequestType] isEqualToString:kRequestTypeHook]) {
                        [self makeRelation:kRequestTypeHook withFriend:friend];
                    }
                    
                    onSuccess();
                } else {
                    onRequestNotFound();
                }
            }];
        } else {
            onRequestNotFound();
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

+ (void)request:(NSString *)requestType
       toFriend:(PFUser *)friend
      onSuccess:(void(^)(void))onSuccess
onRequestAlreadySent:(void (^)(void))onRequestAlreadySent
onRequestAlreadyReceived:(void (^)(void))onRequestAlreadyReceived {
    
    PFObject *request = [PFObject objectWithClassName:kRequestClass];
    
    request[kRequestFromUser] = [PFUser currentUser];
    request[kRequestToUser]   = friend;
    request[kRequestType]     = requestType;
    request[kRequestAccepted] = @NO;
    
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([[error localizedDescription] isEqualToString:@"Request already received"]) {
            onRequestAlreadyReceived();
        } else if ([[error localizedDescription] isEqualToString:@"Request already sent"]) {
            onRequestAlreadySent();
        } else {
            onSuccess();
        }
    }];
}

+ (void)removeRequest:(NSString *)requestType
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

@end
