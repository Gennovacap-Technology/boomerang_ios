//
//  ChatManager.h
//  Bangarang
//
//  Created by Thales Pereira on 9/7/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

#import "Message.h"

@class ChatManager;

@protocol ChatManagerDelegate
-(void)receiveMessage:(JSQMessage *)message;
@end

@interface ChatManager : NSObject

@property (nonatomic, assign) id  delegate;

- (id)initWith:(PFUser *)currentUser_ andUser:(PFUser *)friend_;
- (void)sendMessage:(JSQMessage *)message;
- (void)destroy;

@end
