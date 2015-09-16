//
//  MakeLoveAgainViewController.h
//  Bangarang
//
//  Created by Thales Pereira on 9/16/15.
//  Copyright (c) 2015 Gennovacap. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RequestManager.h"
#import "FriendsManager.h"

@interface MakeLoveAgainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *makeLoveAgainView;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *friendNameBack;

@property (strong, nonatomic) PFUser *friend;
@property (strong, nonatomic) FriendsManager *friendsManager;

- (IBAction)buttonYes:(id)sender;
- (IBAction)buttonNo:(id)sender;
- (IBAction)buttonBack:(id)sender;

@end
