//
//  ChatViewController.m
//  Bangarang
//
//  Created by Thales Pereira on 9/7/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import "ChatViewController.h"

#import "Message.h"
#import "ChatManager.h"

@interface ChatViewController () {
    ChatManager *chatManager;
}

@end

@implementation ChatViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.messages = [[NSMutableArray alloc] init];
    
    // Chat Users
    self.currentUser = [PFUser currentUser];
    
    self.senderId = _currentUser.objectId;
    self.senderDisplayName = _currentUser.username;
    
    // Chat Manager
    chatManager = [[ChatManager alloc] initWith:self.currentUser andUser:self.friendUser];
    chatManager.delegate = self;
    
    // Bubble Images
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    UIColor *bubbleColorOut = [UIColor colorWithWhite:0.800 alpha:0.100];
    UIColor *bubbleColorIn = [UIColor colorWithRed:1.000 green:0.000 blue:0.506 alpha:0.100];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:bubbleColorOut];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:bubbleColorIn];
    
    // Remove Avatar
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundLogin"]];
    [backgroundImage setContentMode:UIViewContentModeScaleAspectFit];
    
    // Send Button
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"ButtonSend"];
    [sendButton setImage:btnImage forState:UIControlStateNormal];
    
    self.inputToolbar.contentView.rightBarButtonItem = sendButton;
    
    // Text input bar
    [self.inputToolbar.contentView setBackgroundColor:[UIColor colorWithWhite:0.157 alpha:1.000]];
    [self.inputToolbar.contentView.textView setBackgroundColor:[UIColor colorWithWhite:0.157 alpha:1.000]];
    [self.inputToolbar.contentView.textView.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorWithWhite:0.157 alpha:1.000])];
    [self.inputToolbar.contentView.textView setTextColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.506 alpha:1.000]];
    [self.inputToolbar.contentView.textView setPlaceHolder:@"Type something..."];
    [self.inputToolbar.contentView.textView setPlaceHolderTextColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.506 alpha:0.500]];
    
    [self.collectionView.backgroundView addSubview:backgroundImage];
    
    [self setAutomaticallyScrollsToMostRecentMessage:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [chatManager destroy];
}

- (void)receiveMessage:(JSQMessage *)message {
    [self.messages addObject:message];
    
    [self finishReceivingMessage];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [JSQMessage messageWithSenderId:senderId
                                              displayName:senderDisplayName
                                                     text:text];
    
    [chatManager sendMessage:message];
    
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

/*- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
 {
 if (indexPath.item % 3 == 0) {
 JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
 
 return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
 }
 
 return nil;
 }*/

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor whiteColor];
    } else {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    return cell;
}


@end

