//
//  ChatManager.m
//  Bangarang
//
//  Created by Thales Pereira on 9/7/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "ChatManager.h"

#import <Parse/Parse.h>
#import <Firebase/Firebase.h>

@interface ChatManager()
{
    NSString *groupId;
    PFUser *currentUser;
    PFUser *friend;
    Firebase *myRootRef;
}

@end

@implementation ChatManager

@synthesize delegate;

- (id)initWith:(PFUser *)currentUser_
       andUser:(PFUser *)friend_
{
    self = [super init];
    
    currentUser = currentUser_;
    friend = friend_;
    
    groupId = [self chatRoomIdFor:currentUser and:friend];
    
    NSString *firebaseURL = [NSString stringWithFormat:@"%@/messages/%@", kFirebaseUrl, groupId];
    
    myRootRef = [[Firebase alloc] initWithUrl:firebaseURL];
    
    [self receivedMessageObserver];
    
    return self;
}

- (NSString *)chatRoomIdFor:(PFUser *)user1
                        and:(PFUser *)user2
{
    NSString *id1 = user1.objectId;
    NSString *id2 = user2.objectId;
    
    groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
    
    return groupId;
}

- (void)sendMessage:(JSQMessage *)message
{
    Firebase *reference = [myRootRef childByAutoId];
    
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    
    item[@"senderId"] = message.senderId;
    item[@"date"] = [self dateToString:message.date];
    item[@"text"] = message.text;
    
    [reference setValue:item];
}

- (void)receivedMessageObserver
{
    [myRootRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:snapshot.value[@"senderId"]
                                                 senderDisplayName:currentUser.username
                                                              date:snapshot.value[@"date"]
                                                              text:snapshot.value[@"text"]];
        
        [delegate receiveMessage:message];
    }];
}

- (void)destroy
{
    delegate = nil;
    
    [myRootRef removeAllObservers];
}

- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [formatter stringFromDate:date];
}

@end