//
//  RequestsManager.m
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "FriendsManager.h"

#import "ParseUtils.h"

@implementation FriendsManager {
    NSMutableArray *friends;
    NSMutableArray * friendsOfGender;
    
    NSMutableArray *bangRequestsSent;
    NSMutableArray *hookRequestsSent;
    
    NSMutableArray *bangRequestsReceived;
    NSMutableArray *hookRequestsReceived;
    
    NSMutableArray *bangs;
    NSMutableArray *hooks;
    
    NSString *currentGender;
}

#pragma mark Singleton Methods

+ (id)sharedManager {
    static FriendsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    
    friends = [[NSMutableArray alloc] init];
    friendsOfGender = [[NSMutableArray alloc] init];
    
    bangRequestsSent = [[NSMutableArray alloc] init];
    hookRequestsSent = [[NSMutableArray alloc] init];
    
    bangRequestsReceived = [[NSMutableArray alloc] init];
    hookRequestsReceived = [[NSMutableArray alloc] init];
    
    bangs = [[NSMutableArray alloc] init];
    hooks = [[NSMutableArray alloc] init];
    
    currentGender = kFacebookMaleString;
    
    return self;
}

- (void)loadFriends:(void (^)(void))onSuccess {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id" forKey:@"fields"];
    
    FBSDKGraphRequest *requestFriends = [[FBSDKGraphRequest alloc]
                                         initWithGraphPath:@"/me/friends"
                                         parameters:parameters
                                         HTTPMethod:@"GET"];
    
    [requestFriends startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                 id result,
                                                 NSError *error) {
        
        if (error) {
            NSLog(@"Facebook Request Error");
        } else {
            NSArray *data = [result objectForKey:@"data"];
            NSMutableArray *facebookFriends = [[NSMutableArray alloc] initWithCapacity:[data count]];
            
            for (NSDictionary *friendData in data) {
                if (friendData[@"id"]) {
                    [facebookFriends addObject:friendData[@"id"]];
                }
            }
            
            dispatch_group_t group = dispatch_group_create();
            
            dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self loadRelations];
            });
            
            dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                friends = [NSMutableArray arrayWithArray:[[ParseUtils friends:facebookFriends] findObjects]];
                [self setCurrentGender:currentGender];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    onSuccess();
                });
            });
        }
    }];
}

- (void)loadRelations {
    PFUser *currentUser = [PFUser currentUser];
    
    PFRelation *relation = [currentUser relationForKey:kUserBangsKey];
    PFQuery *query = [relation query];
    
    [bangs addObjectsFromArray:[query findObjects]];
    
    relation = [currentUser relationForKey:kUserHooksKey];
    query = [relation query];
    
    [hooks addObjectsFromArray:[query findObjects]];
}

- (void)loadRequests:(void (^)(NSUInteger))onSuccess {
    [[ParseUtils requests] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [bangRequestsSent removeAllObjects];
        [hookRequestsSent removeAllObjects];
        
        [bangRequestsReceived removeAllObjects];
        [hookRequestsReceived removeAllObjects];
        
        NSString *currentUserId = [[PFUser currentUser] objectId];
        NSUInteger requestsReceived = 0;
        
        if (!error) {
            for (PFObject *request in objects) {
                NSString *fromUserId = [request[kRequestFromUser] objectId];
                
                if ([self shouldNotifyFriend:request]) {
                    requestsReceived++;
                }
                
                // Requests sent
                if ([currentUserId isEqualToString:fromUserId]) {
                    PFUser *friend = request[kRequestToUser];
                    
                    // Bang Requests
                    if ([request[kRequestType] isEqualToString:kRequestTypeBang]) {
                        
                        if ([request[kRequestAccepted] boolValue]) {
                            [ParseUtils makeRelation:kRequestTypeBang withFriend:friend];
                            
                            [bangs addObject:friend];
                        } else {
                            [bangRequestsSent addObject:friend];
                        }
                    
                    // Hook Requests
                    } else if([request[kRequestType] isEqualToString:kRequestTypeHook]) {
                        
                        if ([request[kRequestAccepted] boolValue]) {
                            [ParseUtils makeRelation:kRequestTypeHook withFriend:friend];
                            
                            [self removeFriend:friend fromArray:bangs];
                            [hooks addObject:friend];
                        } else {
                            [hookRequestsSent addObject:friend];
                        }
                        
                    }
                    
                // Request received
                } else {
                    
                    // Bang Requests
                    if ([request[kRequestType] isEqualToString:kRequestTypeBang] &&
                        ![request[kRequestAccepted] boolValue]) {
                        PFUser *friend = request[kRequestFromUser];
                        [bangRequestsReceived addObject:friend];
                    
                    // Hook Requests
                    } else if ([request[kRequestType] isEqualToString:kRequestTypeHook] &&
                              ![request[kRequestAccepted] boolValue]) {
                        PFUser *friend = request[kRequestFromUser];
                        [hookRequestsReceived addObject:friend];
                    }
                }
            }
            
            onSuccess(requestsReceived);
        } else {
            NSLog(@"Failed load requests");
        }
    }];
}

- (kFriendRelationIndex)friendRelation:(PFUser *)friend {
    if ([self array:hookRequestsSent containsPFObjectById:friend]) {
        return kFriendHookRequestSent;
    } else if ([self array:bangRequestsSent containsPFObjectById:friend]) {
        return kFriendBangRequestSent;
    } else if ([self array:hooks containsPFObjectById:friend]) {
        return kFriendHookRelation;
    } else if ([self array:bangs containsPFObjectById:friend]) {
        return kFriendBangRelation;
    }
    
    return kFriendNoRelation;
}

- (BOOL)shouldNotifyFriend:(PFObject *)request {
    NSString *fromUserId = [request[kRequestFromUser] objectId];
    NSString *currentUserId = [[PFUser currentUser] objectId];
    
    // Requests sent
    if ([currentUserId isEqualToString:fromUserId]) {
        
        if ([request[kRequestFromUserRead] boolValue]) {
            return NO;
        }
        
        // Confirmed Bang
        if ([request[kRequestType] isEqualToString:kRequestTypeBang]) {
            
            if ([request[kRequestAccepted] boolValue]) {
                return YES;
            }
            
            // Confirmed Hook
        } else if([request[kRequestType] isEqualToString:kRequestTypeHook]) {
            if ([request[kRequestAccepted] boolValue] && request[kRequestToUserRead]) {
                return YES;
            }
        }
        
    // Request received
    } else {
        
        if ([request[kRequestToUserRead] boolValue]) {
            return NO;
        }
        
        // Hook Received
        if ([request[kRequestType] isEqualToString:kRequestTypeHook]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setRequestAsRead:(PFObject *)request {
    NSString *fromUserId = [request[kRequestFromUser] objectId];
    NSString *currentUserId = [[PFUser currentUser] objectId];
    
    if ([currentUserId isEqualToString:fromUserId]) {
        request[kRequestFromUserRead] = @YES;
    } else {
        request[kRequestToUserRead] = @YES;
    }
    
    [request saveInBackground];
}

- (BOOL)receivedBangRequestFromFriend:(PFUser *)friend {
    return [self array:bangRequestsReceived containsPFObjectById:friend];
}

- (BOOL)receivedHookRequestFromFriend:(PFUser *)friend {
    return [self array:hookRequestsReceived containsPFObjectById:friend];
}

- (void)setCurrentGender:(NSString *)gender {
    [friendsOfGender removeAllObjects];
    
    for (PFUser *friend in friends) {
        if ([friend[kUserGenderKey] isEqual:gender]) {
            [friendsOfGender addObject:friend];
        }
    }
}

- (NSMutableArray *)getFriendsOfCurrentGender {    
    return friendsOfGender;
}

- (PFUser *)getFriendOfCurrentGenderAtIndex:(NSUInteger)index {    
    return [[self getFriendsOfCurrentGender] objectAtIndex:index];
}

- (BOOL)array:(NSArray *)array containsPFObjectById:(PFObject *)object {
    for (PFObject *arrayObject in array){
        if ([[arrayObject objectId] isEqual:[object objectId]]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)removeFriend:(PFUser *)friend fromArray:(NSMutableArray *)array {
    for (int i = 0; i < [array count]; i++) {
        if ([[array[i] objectId] isEqual:[friend objectId]]) {
            [array removeObjectAtIndex:i];
        }
    }
}

- (void)addFriendToHooks:(PFUser *)friend {
    [hooks addObject:friend];
}

- (void)addFriendToBangs:(PFUser *)friend {
    [bangs addObject:friend];
}

- (void)addFriendToHookRequestsSent:(PFUser *)friend {
    [hookRequestsSent addObject:friend];
}

- (void)addFriendToBangRequestsSent:(PFUser *)friend {
    [bangRequestsSent addObject:friend];
}

- (void)removeFriendFromHooks:(PFUser *)friend {
    [self removeFriend:friend fromArray:hooks];
}

- (void)removeFriendFromBangs:(PFUser *)friend {
    [self removeFriend:friend fromArray:bangs];
}

- (void)removeFriendFromBangRequestsSent:(PFUser *)friend {
    [self removeFriend:friend fromArray:bangRequestsSent];
}

- (void)removeFriendFromHookRequestsReceived:(PFUser *)friend {
    [self removeFriend:friend fromArray:hookRequestsReceived];
}

- (void)removeFriendFromBangRequestsReceived:(PFUser *)friend {
    [self removeFriend:friend fromArray:bangRequestsReceived];
}

@end
