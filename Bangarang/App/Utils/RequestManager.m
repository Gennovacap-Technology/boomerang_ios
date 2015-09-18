//
//  RequestManager.m
//  Bangarang
//
//  Created by Thales Pereira on 9/14/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "RequestManager.h"

#import <Firebase/Firebase.h>

@interface RequestManager()
{
    Firebase *myRootRef;
}

@end

@implementation RequestManager

@synthesize delegate;

- (void)createRequest:(NSString *)friendId {
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/requests/%@", kFirebaseUrl, friendId];
    
    Firebase *friendRef = [[Firebase alloc] initWithUrl:firebaseURL];
    
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    
    item[@"requests"] = @YES;
    
    [friendRef setValue:item];
}

- (void)requestReceivedObserver {
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/requests/%@", kFirebaseUrl, [[PFUser currentUser] objectId]];
        
    myRootRef = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [myRootRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value == [NSNull null] || snapshot.value) {
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            item[@"requests"] = @NO;
            
            [myRootRef setValue:item];
        }
    }];
    
    [myRootRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value boolValue]) {
            [delegate requestReceived];
            
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            item[@"requests"] = @NO;
            
            [myRootRef setValue:item];            
        }
    }];
}

- (void)destroy {
    delegate = nil;
    
    [myRootRef removeAllObservers];
}

@end
