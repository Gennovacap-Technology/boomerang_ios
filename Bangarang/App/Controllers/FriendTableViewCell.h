//
//  FriendTableViewCell.h
//  Bangarang
//
//  Created by Thales Pereira on 8/29/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendCellDelegate

- (void)requestButtonPressed:(NSInteger)cellIndex fromSender:(id)sender;

@end

@interface FriendTableViewCell : UITableViewCell

@property (nonatomic, assign) id  delegate;
@property (assign, nonatomic) NSInteger cellIndex;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIButton *bombButton;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *status;

- (IBAction)bombAction:(id)sender;

@end
