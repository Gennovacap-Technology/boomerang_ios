//
//  MakeLoveAgainViewController.h
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FriendsListViewController.h"

@interface MakeLoveAgainViewController : UIViewController

@property (nonatomic, weak) id<FriendsListDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *makeLoveAgainView;
@property (weak, nonatomic) IBOutlet UIView *makeLoveAgainText;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendNameBack;
@property (weak, nonatomic) IBOutlet UIImageView *boomImageView;

@property (strong, nonatomic) PFUser *friend;
@property (strong, nonatomic) PFObject *request;

- (IBAction)buttonYes:(id)sender;
- (IBAction)buttonNo:(id)sender;
- (IBAction)buttonBack:(id)sender;

@end
