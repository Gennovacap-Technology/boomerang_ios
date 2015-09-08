//
//  ChatViewController.h
//  Bangarang
//
//  Created by Thales Pereira on 9/7/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "JSQMessagesViewController.h"

#import "JSQMessages.h"
#import "ChatManager.h"

#import <Parse/Parse.h>

@interface ChatViewController : JSQMessagesViewController<ChatManagerDelegate>

@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFUser *friendUser;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSMutableArray *messages;

@end